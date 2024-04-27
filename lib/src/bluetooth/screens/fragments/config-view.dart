import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/domain/config-file.dart';
import 'package:flutter_sit_operation_application/src/shared/styles.dart';
import 'package:flutter_sit_operation_application/src/widgets/app-text-filed.dart';
import 'package:flutter_sit_operation_application/src/widgets/loading-dialog.dart';

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
  var idCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  var wifiCtrl = TextEditingController();
  var wifiPassCtrl = TextEditingController();
  /* MQTT V1 */
  var mqqtServerCtrl = TextEditingController();
  var mqqtUsernameCtrl = TextEditingController();
  var mqqtPasswordCtrl = TextEditingController();
  var mqqtPortCtrl = TextEditingController();
  var mqqtTopicCtrl = TextEditingController();
  var intervalCtrl = TextEditingController();
  /* MQTT V2 */
  var mqqtV2ServerCtrl = TextEditingController();
  var mqqtV2UsernameCtrl = TextEditingController();
  var mqqtV2PasswordCtrl = TextEditingController();
  var mqqtV2PortCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();

    print("ConfigView: >>>> Incomming config ${widget.config.toJson()}");

    idCtrl = TextEditingController(text: widget.config.uid);
    nameCtrl = TextEditingController(text: widget.config.slug);
    wifiCtrl = TextEditingController(text: widget.config.wifiSsid);
    wifiPassCtrl = TextEditingController(text: widget.config.wifiPassword);
    mqqtServerCtrl =
        TextEditingController(text: widget.config.mqqtConfig.server);
    mqqtPortCtrl = TextEditingController(text: widget.config.mqqtConfig.port);
    mqqtUsernameCtrl =
        TextEditingController(text: widget.config.mqqtConfig.username);
    mqqtPasswordCtrl =
        TextEditingController(text: widget.config.mqqtConfig.password);
    mqqtTopicCtrl = TextEditingController(text: widget.config.mqqtConfig.topic);
    intervalCtrl = TextEditingController(text: widget.config.readInterval);

    mqqtV2ServerCtrl =
        TextEditingController(text: widget.config.mqqtV2Config.server);
    mqqtV2PortCtrl =
        TextEditingController(text: widget.config.mqqtV2Config.port);
    mqqtV2UsernameCtrl =
        TextEditingController(text: widget.config.mqqtV2Config.username);
    mqqtV2PasswordCtrl =
        TextEditingController(text: widget.config.mqqtV2Config.password);
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
    print("******* TRYING TO SUBMIT NEW CONFIG");

    final idText = idCtrl.text;
    final nameText = nameCtrl.text;
    final wifiText = wifiCtrl.text;
    final wifiPasswordText = wifiPassCtrl.text;

    /* mqtt v1 */
    final mqqtServerText = mqqtServerCtrl.text;
    final mqqtPortText = mqqtPortCtrl.text;
    final mqqtUsernameText = mqqtUsernameCtrl.text;
    final mqqtPasswordText = mqqtPasswordCtrl.text;
    final mqqtTopicText = mqqtTopicCtrl.text;
    final intervalText = intervalCtrl.text;

       /* mqtt v2 */
    final mqqtV2ServerText = mqqtV2ServerCtrl.text;
    final mqqtV2PortText = mqqtV2PortCtrl.text;
    final mqqtV2UsernameText = mqqtV2UsernameCtrl.text;
    final mqqtV2PasswordText = mqqtV2PasswordCtrl.text;

    MqqtConfig config = MqqtConfig(mqqtServerText, mqqtUsernameText,
        mqqtPasswordText, mqqtPortText, mqqtTopicText);

    MqqtConfig mqttConfig2 = MqqtConfig(mqqtV2ServerText, mqqtV2UsernameText,
        mqqtV2PasswordText, mqqtV2PortText, "");

    ConfigData newConfig = ConfigData(
        idText,
        nameText,
        wifiText,
        wifiPasswordText,
        config,
        mqttConfig2,
        intervalText);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const LoadingDialog(
          title: "Salvando",
          subtitle: "A estação será reiniciada em seguida.",
        );
      });

    print("NewConfig: ${newConfig.toJson()}");

    var succeded = await widget.onSubmit(newConfig);

    Navigator.of(context).pop();
    print('ConfigView: resultado aqui ${succeded}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor, // Set the background color
        title: const Text(
          "Atualizar Configuração",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                "INTERNET",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 30, 44),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(),
              const SizedBox(height: 8),
              AppTextField(
                  label: "Wifi", controller: wifiCtrl, initialValue: ""),
              const SizedBox(height: 8),
              AppTextField(
                  label: "Senha wifi",
                  controller: wifiPassCtrl,
                  initialValue: ""),
              const SizedBox(height: 16),
              const Text(
                "IDENTIFICAÇÃO",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 30, 44),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 150,
                      child: AppTextField(
                          label: "Slug",
                          controller: nameCtrl,
                          initialValue: ""),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      width: 120,
                      child: AppTextField(
                          label: "ID (legado)",
                          controller: idCtrl,
                          initialValue: ""),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "MQTT (MEDIÇÕES)",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 30, 44),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: 150,
                        child: AppTextField(
                            label: "Mqqt host",
                            controller: mqqtServerCtrl,
                            initialValue: "")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                        width: 120,
                        child: AppTextField(
                            label: "Mqqt port",
                            controller: mqqtPortCtrl,
                            initialValue: "")),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: AppTextField(
                          label: "Mqqt username",
                          controller: mqqtUsernameCtrl,
                          initialValue: ""),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                          child: AppTextField(
                              label: "Mqqt Senha",
                              controller: mqqtPasswordCtrl,
                              initialValue: "")),
                    ),
                  ),
                ],
              ),
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
              /*  */

              const SizedBox(height: 16),
              const Text(
                "MQTT (OTA)",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 30, 44),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: 150,
                        child: AppTextField(
                            label: "Mqqt host",
                            controller: mqqtV2ServerCtrl,
                            initialValue: "")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                        width: 120,
                        child: AppTextField(
                            label: "Mqqt port",
                            controller: mqqtV2PortCtrl,
                            initialValue: "")),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: AppTextField(
                          label: "Mqqt username",
                          controller: mqqtV2UsernameCtrl,
                          initialValue: ""),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                          child: AppTextField(
                              label: "Mqqt Senha",
                              controller: mqqtV2PasswordCtrl,
                              initialValue: "")),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 86,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14.0), // Button border radius
                    ),
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 248, 248, 248),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
