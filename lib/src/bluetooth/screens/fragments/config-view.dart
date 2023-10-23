import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';
import 'package:flutter_sit_operation_application/src/widgets/app-text-filed.dart';

class ConfigView extends StatefulWidget {
  final ConfigData config;
  final Future<bool> Function(ConfigData) onSubmit;

  const ConfigView({
    super.key,
    required this.config,
    required this.onSubmit,
  });

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  bool _isLoading = false;
  var idCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  var wifiCtrl = TextEditingController();
  var wifiPassCtrl = TextEditingController();
  var mqqtServerCtrl = TextEditingController();
  var mqqtUsernameCtrl = TextEditingController();
  var mqqtPasswordCtrl = TextEditingController();
  var mqqtPortCtrl = TextEditingController();
  var mqqtTopicCtrl = TextEditingController();
  var intervalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("ConfigView: >>>> Incomming config ${widget.config.toJson()}");
    idCtrl = TextEditingController(text: widget.config.uid);
    nameCtrl = TextEditingController(text: widget.config.name);
    wifiCtrl = TextEditingController(text: widget.config.wifiSsid);
    wifiPassCtrl = TextEditingController(text: widget.config.wifiPassword);
    mqqtServerCtrl = TextEditingController(text: widget.config.mqqtServer);
    mqqtPortCtrl = TextEditingController(text: widget.config.mqqtPort);
    mqqtUsernameCtrl = TextEditingController(text: widget.config.mqqtUsername);
    mqqtPasswordCtrl = TextEditingController(text: widget.config.mqqtPassword);
    mqqtTopicCtrl = TextEditingController(text: widget.config.mqqtTopic);
    intervalCtrl = TextEditingController(text: widget.config.readInterval);
  }

  @override
  void dispose() {
    idCtrl.dispose();
    nameCtrl.dispose();
    wifiCtrl.dispose();
    wifiPassCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    print("******* TRYING TO SUBMIT NEW CONFIG");

    final idText = idCtrl.text;
    final nameText = nameCtrl.text;
    final wifiText = wifiCtrl.text;
    final wifiPasswordText = wifiPassCtrl.text;
    final mqqtServerText = mqqtServerCtrl.text;
    final mqqtPortText = mqqtPortCtrl.text;
    final mqqtUsernameText = mqqtUsernameCtrl.text;
    final mqqtPasswordText = mqqtPasswordCtrl.text;
    final mqqtTopicText = mqqtTopicCtrl.text;
    final intervalText = intervalCtrl.text;

    ConfigData newConfig = ConfigData(
        idText,
        nameText,
        wifiText,
        wifiPasswordText,
        mqqtServerText,
        mqqtUsernameText,
        mqqtPasswordText,
        mqqtTopicText,
        mqqtPortText,
        intervalText);

    var succeded = await widget.onSubmit(newConfig);
    print('ConfigView: resultado aqui ${succeded}');

    setState(() {
      _isLoading = false;
    });
  }

  void _handleChange(String v) {
    /* if (_isEdited == false) {
      print('Começou a editar agora! Notificar que valor foi trocado');
      setState(() {
        _isEdited = true;
      });
      widget.onChange(v);
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppTextField(
              label: "Id da estação", controller: idCtrl, initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Nome da estação", controller: nameCtrl, initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(label: "Wifi", controller: wifiCtrl, initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Senha wifi", controller: wifiPassCtrl, initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Mqqt host", controller: mqqtServerCtrl, initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Mqqt port", controller: mqqtPortCtrl, initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Mqqt username",
              controller: mqqtUsernameCtrl,
              initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Mqqt Senha",
              controller: mqqtPasswordCtrl,
              initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Mqqt topico",
              controller: mqqtTopicCtrl,
              initialValue: ""),
          const SizedBox(height: 8),
          AppTextField(
              label: "Intervalo de medições",
              controller: intervalCtrl,
              initialValue: ""),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 32.0)),
            onPressed: _handleSubmit,
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }
}
