import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MyEmbeddedScriptWidget extends StatefulWidget {
  const MyEmbeddedScriptWidget({super.key});

  @override
  State<MyEmbeddedScriptWidget> createState() => _MyEmbeddedScriptWidgetState();
}

class _MyEmbeddedScriptWidgetState extends State<MyEmbeddedScriptWidget> {
  final html.IFrameElement _iFrameElement = html.IFrameElement();

  @override
  void initState() {
    super.initState();
    _iFrameElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElementChat',
      (int viewId) => _iFrameElement,
    );
    html.document.body?.append(_iFrameElement);

    // Thực thi đoạn mã JavaScript sau khi iFrame được tạo
    html.window.onLoad.listen((event) {
      js.context.callMethod('eval', [
        """
      <script>
        (function(w,d,u){
                var s=d.createElement('script');s.async=true;s.src=u+'?'+(Date.now()/60000|0);
                var h=d.getElementsByTagName('script')[0];h.parentNode.insertBefore(s,h);
        })(window,document,'https://cdn.bitrix24.com/b13397827/crm/site_button/loader_32_3bnk7b.js');
</script>
        """
      ]);
    });
  }

  final Widget _iframWidget = HtmlElementView(
    key: UniqueKey(),
    viewType: 'iframeElementChat',
  );
  @override
  void dispose() {
    _iFrameElement.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _iframWidget;
  }
}
