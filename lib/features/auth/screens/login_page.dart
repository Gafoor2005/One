import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/auth/widgets/large_button.dart';
import 'package:one/features/auth/widgets/one_logo.dart';
import 'package:url_launcher/url_launcher.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
final acceptedPolicyProvider = StateProvider<bool>((ref) => false);
final loginWidgetPageProvider = StateProvider<int>((ref) => 0);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailController;

  String body = '';
  void loadStr() async {
    body = await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadStr();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void signin() {
    setState(() {
      page = 0;
    });
    if (acceptedPolicy) {
      ref
          .read(authControllerProvider.notifier)
          .signInWithMS(context, "consent", _emailController.text);
    }
  }

  int page = 0;
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  bool isMailValid = false;
  bool acceptedPolicy = false;

  @override
  Widget build(BuildContext mycontext) {
    List<Widget> loginWidgets = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
          ),
          const OneLogo(),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 276,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 62,
                  decoration: BoxDecoration(
                      color: const Color(0xAAEEEEEE),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x22000000))),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      // labelText: "Email",
                      hintText: "Email",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 31,
                        vertical: 18,
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (String mail) {
                      bool resultMatch = emailRegex.hasMatch(mail);
                      if (resultMatch != isMailValid) {
                        setState(() {
                          isMailValid = resultMatch;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          LargeButton(
            text: "Next",
            onTap: isMailValid
                ? () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (acceptedPolicy) {
                      signin();
                    } else {
                      setState(() {
                        page++;
                      });
                    }
                    // showSnackBar(context, "User cancled operation");
                  }
                : null,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40.0, bottom: 20),
            child: SizedBox(
              width: 270,
              child: Divider(
                thickness: 2,
                color: Colors.black12,
              ),
            ),
          ),
          LargeButton(
            buttonIcon: "microsoft",
            onTap: () {
              ref
                  .read(authControllerProvider.notifier)
                  .signInWithMS(context, "none", _emailController.text);
            },
            text: "SSO",
          ),
        ],
      ),
      Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 276,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 0,
                ),
                const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontVariations: [
                      FontVariation('ital', 0),
                      FontVariation('slnt', 0),
                      FontVariation('wght', 800)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
                (body.isEmpty)
                    ? const SizedBox(width: 100, height: 100, child: Loader())
                    : const Text(
                        "One and its developer take your privacy very seriously. One does not sell or rent your data, and anonymous information is only collected to help make the app better.\n\nWhen signing into One, it requests specific permissions from your Microsoft account, such as the ability to read basic user details. So that, we can verify the user and personalize their experience.",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                        ),
                      ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "If you have questions or concerns about any of the above please contact",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(Uri.parse('mailto:Gafoor@devloopers.me'));
                  },
                  child: Text(
                    "Gafoor@Devloopers.me",
                    style: TextStyle(
                      fontFamily: "NotoSans",
                      color: Colors.blue.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  // spacing: 20,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: TextButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse("https://devloopers.me"));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(121, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black12,
                              )),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Privacy Policy"),
                            SizedBox(
                              width: 5,
                            ),
                            SvgPicture.asset("assets/icons/window_new.svg"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                LargeButton(
                  onTap: () {
                    acceptedPolicy = true;

                    setState(() {
                      page = 0;
                    });
                    signin();
                  },
                  text: "Next",
                ),
              ],
            ),
          ),
        ),
      ),
    ];
    final isLoading = ref.watch(authControllerProvider);
    // ref.watch(userProvider.notifier).update((state) => null);
    // ref.watch(attendanceProvider.notifier).update((state) => null);
    // ref.watch(bioProvider.notifier).update((state) => null);

    // aadOAuth.hasCachedAccountInformation
    //     .then((value) => log("aad cache: ${value.toString()}"));

    return Builder(builder: (mycontext) {
      return Scaffold(
        backgroundColor: const Color(0xFAFFFFFF),
        body: isLoading
            ? const Center(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Loader(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Getting content.."),
                ],
              ))
            : IndexedStack(
                index: page,
                children: loginWidgets,
              ),
      );
    });
  }
}
