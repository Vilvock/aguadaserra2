import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

import '../res/strings.dart';
import 'application_messages.dart';

class Validator {
  BuildContext context;

  Validator({Key? key, required this.context});

  bool validateEmail(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      ApplicationMessages(context: context).showMessage(Strings.email_denied);
      return false;
    }
  }

  bool validatePassword(String password) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (password.isEmpty) {
      ApplicationMessages(context: context)
          .showMessage(Strings.password_denied);
      return false;
    } else {
      if (!regex.hasMatch(password)) {
        ApplicationMessages(context: context)
            .showMessage(Strings.password_denied);
        return false;
      } else {
        return true;
      }
    }
  }

  bool validateCoPassword(String password, String coPassword) {
    if (password == coPassword) {
      return true;
    } else {
      ApplicationMessages(context: context)
          .showMessage(Strings.coPassword_denied);
      return false;
    }
  }

  bool validateCellphone(String cellphone) {
    if (cellphone.length > 14) {
      return true;
    } else {
      ApplicationMessages(context: context)
          .showMessage(Strings.cellphone_denied);
      return false;
    }
  }

  bool validateCPF(String cpf) {
    if (CPFValidator.isValid(cpf)) {
      return true;
    } else {
      ApplicationMessages(context: context).showMessage(Strings.cpf_denied);
      return false;
    }
  }

  bool validateCNPJ(String cnpj) {
    if (CNPJValidator.isValid(cnpj)) {
      return true;
    } else {
      ApplicationMessages(context: context).showMessage(Strings.cnpj_denied);
      return false;
    }
  }

  bool validateGenericTextField(String text, String field) {
    if (text.isNotEmpty) {
      return true;
    } else {
      ApplicationMessages(context: context)
          .showMessage("$field não pode estar vazio!");
      return false;
    }
  }
}
