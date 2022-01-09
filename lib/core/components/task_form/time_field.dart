import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/features/utils/form_manager.dart';

class TimeField extends StatefulWidget {
  TimeField({
    Key? key,
    this.labelText,
    this.controller,
    this.validator,
    this.enabled,
    this.clearButton,
    this.focusNode,
    this.requestNode,
  }) : super(key: key);
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function()? clearButton;
  final FocusNode? focusNode;
  final VoidCallback? requestNode;
  final bool? enabled;
  final OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blueGrey));
  @override
  _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  @override
  Widget build(BuildContext context) {
    TimeOfDay _turkeyTime = TimeOfDay(
        hour: TimeOfDay.now().hour + 3, minute: TimeOfDay.now().minute);
    void selectTime(TextEditingController date) async {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _turkeyTime,
      );
      if (newTime != null) {
        setState(() {
          _turkeyTime = newTime;
          date.value = TextEditingValue(text: newTime.format(context));
        });
        widget.requestNode!.call();
      }
      if (date.value.text.isNotEmpty) {
        Provider.of<FormManager>(context, listen: false)
            .changeDurationBool(false);
      } else {
        Provider.of<FormManager>(context, listen: false)
            .changeDurationBool(true);
      }
    }

    return TextFormField(
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 24.0, 0.0, 16.0),
          suffixIcon: IconButton(
            onPressed: widget.clearButton,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.clear,
              color: Colors.deepOrange[800],
            ),
            iconSize: 15,
          ),
          labelText: widget.labelText,
          enabledBorder:
              widget.controller!.text.isNotEmpty ? widget._border : null,
          border: widget._border),
      controller: widget.controller,
      onTap: () => selectTime(widget.controller!),
      validator: widget.validator,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.next,
    );
  }
}
