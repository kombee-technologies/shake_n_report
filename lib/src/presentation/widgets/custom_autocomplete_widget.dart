import 'package:flutter/material.dart';

class CustomAutocompleteField<T extends Object> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final List<T> options;
  final T? initialValue;
  final String Function(T option) displayStringForOption;
  final void Function(T selection) onSelected;
  final Widget Function(BuildContext context, T option) optionViewBuilder;
  final FormFieldValidator<String>? validator;
  final bool Function(T option, String query)? filterCondition;
  final VoidCallback? onClear;
  final bool isReadOnly;

  const CustomAutocompleteField({
    required this.options,
    required this.displayStringForOption,
    required this.onSelected,
    required this.optionViewBuilder,
    this.isReadOnly = false,
    super.key,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.filterCondition,
    this.onClear,
  });

  @override
  State<CustomAutocompleteField<T>> createState() =>
      _CustomAutocompleteFieldState<T>();
}

class _CustomAutocompleteFieldState<T extends Object>
    extends State<CustomAutocompleteField<T>> {
  T? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomAutocompleteField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      _selectedOption = widget.initialValue;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Autocomplete<T>(
        displayStringForOption: widget.displayStringForOption,
        initialValue: widget.initialValue != null
            ? TextEditingValue(
                text: widget.displayStringForOption(widget.initialValue as T))
            : null,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            // If text is empty, and it was previously a selected option's display string,
            // it means the user cleared it manually.
            if (_selectedOption != null &&
                widget.displayStringForOption(_selectedOption as T) != '') {
              // This check helps if the user backspaces the selected item text
              // We should clear our internal _selectedOption state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _selectedOption != null) {
                  // Check mounted before setState
                  setState(() {
                    _selectedOption = null;
                  });
                  widget.onClear?.call();
                }
              });
            }
            return Iterable<T>.empty();
          }
          return widget.options.where((T option) {
            if (widget.filterCondition != null) {
              return widget.filterCondition!(option, textEditingValue.text);
            }
            return widget
                .displayStringForOption(option)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (T selection) {
          if (widget.isReadOnly) {
            return;
          }

          setState(() {
            _selectedOption = selection;
            // The Autocomplete widget itself updates the text field's controller
            // when an option is selected. If we are using an external controller,
            // it should also be updated by Autocomplete.
            // If internal, Autocomplete handles it.
          });
          widget.onSelected(selection);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) =>
            TextFormField(
          controller:
              fieldTextEditingController, // Use controller from Autocomplete
          focusNode: fieldFocusNode,
          readOnly: widget.isReadOnly,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0)), // Example border
            suffixIcon: _selectedOption != null ||
                    fieldTextEditingController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      if (widget.isReadOnly) {
                        return;
                      }
                      fieldTextEditingController.clear();
                      setState(() {
                        _selectedOption = null;
                      });
                      widget.onClear?.call();
                      // After clearing, optionsBuilder will be called with empty text,
                      // returning empty options.
                      // FocusManager.instance.primaryFocus?.unfocus(); // Optional: unfocus
                    },
                  )
                : null,
          ),
          validator: (String? value) {
            // Call the provided validator
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
          onFieldSubmitted: (_) => onFieldSubmitted(),
        ),
        optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<T> onSelected, Iterable<T> options) =>
            Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final T option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      if (!widget.isReadOnly) {
                        onSelected(option);
                      }
                    },
                    child: widget.optionViewBuilder(context, option),
                  );
                },
              ),
            ),
          ),
        ),
      );
}
