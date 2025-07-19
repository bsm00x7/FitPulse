import 'package:fitness/core/featuers/complete/controller/complete_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../widget/TextFormFild.dart';
class Complete extends StatelessWidget {
  const Complete({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return CompleteController();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "lib/assets/complete/dumbbell-solid.svg",
                      height: 170,
                      width: 170,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Let’s complete your profile",
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "It will help us to know more about you!",
                      style: theme.textTheme.displaySmall!.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    Consumer<CompleteController>(
                      builder: (
                          BuildContext context,
                          CompleteController value,
                          Widget? child,
                          ) =>
                          Form(
                            key:value.key ,
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                TextFormFieldWidget(
                                  source: 'lib/assets/complete/2 User.svg',
                                  hint: 'Choose Gender',
                                  controller: value.gender,
                                  errorValidator: 'Please enter Your First Name',
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: value.birth,
                                  validator: (String? value){
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please Take Your Birth Day";
                                    }
                                  },

                                  readOnly: true,
                                  onTap: () {
                                    value.pickDate(context);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF7F8F8),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SvgPicture.asset(
                                        'lib/assets/complete/Calendar.svg',
                                        width: 18,
                                        height: 18,
                                        colorFilter: ColorFilter.mode(
                                          theme.iconTheme.color ?? Colors.grey,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    hintText: "Enter Your Birth",
                                    hintStyle: theme.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6, // Give more space to the weight input
                                      child: TextFormFieldWidget(
                                        source: 'lib/assets/complete/weight.svg',
                                        hint: "Your Weight",
                                        controller: value.weight,
                                        errorValidator: "Please enter Your weight",
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                                        ],

                                        obscureText: false,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(14)
                                      ),
                                      child: Center(child: Text("KG" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w600),)),
                                    ))

                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6, // Give more space to the weight input
                                      child: TextFormFieldWidget(
                                        source: 'lib/assets/complete/Swap.svg',
                                        hint: "Your Height",
                                        controller: value.height,
                                        errorValidator: "Please enter Your Height",
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                                        ],
                                        obscureText: false,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: theme.colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(14)
                                      ),
                                      child: Center(child: Text("CM" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.w600),)),
                                    ))

                                  ],
                                ),
                                const SizedBox(height: 120),
                                ElevatedButton(
                                  onPressed: (){value.nextComplete(context);},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'lib/assets/login/LoginDor.svg',
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Login",
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color:
                                          theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}