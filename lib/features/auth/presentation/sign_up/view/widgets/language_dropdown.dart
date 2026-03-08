import 'package:arabic/features/auth/presentation/manager/language/language_cubit.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/widgets/glass_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageDropdown extends StatefulWidget {
  final Function(int langId)? onChanged;
  const LanguageDropdown({super.key, this.onChanged});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  int? selectedLanguageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageCubit>().getLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final cubit = context.read<LanguageCubit>();

        // Show loading or error states if needed
        if (state is LanguageLoading) {
          return const GlassDropdownField<int>(
            hintText: 'Loading languages...',
            prefixIcon: Icons.language,
            items: [],
          );
        }

        return GlassDropdownField<int>(
          hintText: 'Native Language',
          prefixIcon: Icons.language,
          value: selectedLanguageId,
          items: cubit.languages
              .map(
                (language) => DropdownMenuItem<int>(
                  value: language.id,
                  child: Text(language.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedLanguageId = value;
            });
            // Call the callback with the language ID
            if (value != null) {
              widget.onChanged?.call(value);
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your native language';
            }
            return null;
          },
        );
      },
    );
  }
}
