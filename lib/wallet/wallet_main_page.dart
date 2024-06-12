// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialswap/wallet/components/wallet/balance.dart';
import 'package:socialswap/wallet/components/wallet/copyable_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'components/dialog/alert.dart';
import 'components/menu/main_menu.dart';
import 'components/wallet/change_network.dart';
import 'context/wallet/wallet_provider.dart';
import 'package:socialswap/service/shared_pref.dart';

class WalletMainPage extends HookWidget {
  const WalletMainPage(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final store = useWallet(context);
    final address = store.state.address;
    final network = store.state.network;

    // user wallet pref data //
    final pk = useState<String?>(null);
    final addr = useState<String?>(null);
    final chk = useState<String?>(null);

    // user data //
    final currentUserID = useState<String?>(null);

    useEffect(() {
      store.initialise();
      return null;
    }, []);

    useEffect(
      () => store.listenTransfers(address, network),
      [address, network],
    );

    useEffect(() {
      onLoad() async {
        try {
          pk.value = await SharedPreferenceHelper().getPrivateKey();
           addr.value = await SharedPreferenceHelper().getAddress();
          chk.value = await SharedPreferenceHelper().getStoreCheck();
          currentUserID.value = await SharedPreferenceHelper().getUserId();

          
          // Debugging output
          print(
              "pk: ${pk.value}, addr: ${addr.value}, chk: ${chk.value}, currentUserID: ${currentUserID.value}");

        } catch (e) {
          print("Error fetching data from Shared Preferences: $e");
        }

        try {
          if(chk.value == "false") {
            if(addr.value != null && pk.value != null) {
              
              // updating current user pk and addr in firebase //
              try {
                await FirebaseFirestore.instance.collection("users").doc(currentUserID.value).update({
                  "address": addr.value,
                  "privateKey": pk.value
                });
              }
              catch(e) {
                print("Error updating data in Firebase: $e");
              }
              print("updating");

              await SharedPreferenceHelper().saveStoreCheck("true");
            }
            else {
              return;
            }
          }
        }
        catch (e) {
          print("Error updating data in Shared Preferences: $e");
        }
      }

      store.initialise();
      onLoad();


      return null;
    }, []);

    return Scaffold(
      drawer: MainMenu(
        network: network,
        address: address,
        onReset: () => Alert(
            title: 'Warning',
            text:
                'Without your seed phrase or private key you cannot restore your wallet balance',
            actions: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('reset'),
                onPressed: () async {
                  await store.resetWallet();
                  Navigator.popAndPushNamed(context, '/');
                },
              )
            ]).show(context),
        onRevealKey: () => Alert(
            title: 'Private key',
            text:
                'WARNING: In production environment the private key should be protected with password.\r\n\r\n${store.getPrivateKey() ?? "-"}',
            actions: [
              TextButton(
                child: const Text('close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('copy and close'),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: store.getPrivateKey() ?? ''));
                  Navigator.of(context).pop();
                },
              ),
            ]).show(context),
      ),
      appBar: AppBar(
        title: Text(title),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: !store.state.loading
                  ? () async {
                      await store.refreshBalance();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Balance updated'),
                        duration: Duration(milliseconds: 800),
                      ));
                    }
                  : null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/transfer', arguments: store.state.network);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.upload),
            //   onPressed: () async {
            //     chk.value = await SharedPreferenceHelper().getStoreCheck();
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.downloading),
            //   onPressed: () async {
            //     print("addr: ${addr.value}");
            //     print("pk: ${pk.value}");
            //     print("id: ${currentUserID.value}");
            //     print("chk: ${chk.value}");
            //   },
            // ),
            ChangeNetwork(
              onChange: store.changeNetwork,
              currentValue: store.state.network,
              loading: store.state.loading,
            ),
            const SizedBox(height: 10),
            CopyableAddress(address: store.state.address),
            Balance(
              balance: store.state.tokenBalance,
              symbol: 'tokens',
              fontSizeDelta: 6,
            ),
            Balance(
              balance: store.state.ethBalance,
              symbol: network.config.symbol,
              fontColor: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
