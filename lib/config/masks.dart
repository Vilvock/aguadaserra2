import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Masks {

  MaskTextInputFormatter cellphoneMask() {
    return MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);
  }

  MaskTextInputFormatter cpfMask() {
    return MaskTextInputFormatter(
        mask: '###.###.###-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  MaskTextInputFormatter cnpjMask() {
    return MaskTextInputFormatter(
        mask: '##.###.###/####-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }


}