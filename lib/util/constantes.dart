class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =25;
  static const int DOCUMENT_FIRST = 1 ;
  static const int DOCUMENT_SECOND = 2 ;
  static const int VACUNA_INIT = 3;
  static const int VACUNA_HOME = 4;

  // DOCUMENTO IDENTIDAD
  static const String TITLE_DOCUMENTO_IDENTIDAD = 'Documento de identidad';
  static const String KEY_DOCUMENTO_IDENTIDAD = "DOCUMENT_IDENTIDAD";
  static const String DOCUMENT_VACUUM = "DOCUMENT_VACUUM";
  static const String COVID = "Vacuna PDF";

  // VACUNA
  static const String TITLE_CERTIFICADO_VACUNA = 'Certificado de Vacunas';
  static const String KEY_CERTIFICADO_VACUNA = "CERTIFICADO_VACUNA";

  // PASE MEDICO
  static const String TITLE_PASE_MEDICO = "Pase Médico";
  static const String KEY_PASE_MEDICO = "PASE_MEDICO";
  static const int PASE_MEDICO_FIRST_PAGE = 1;
  static const int PASE_MEDICO_SECOND_PAGE = 2;

  // COVID
  static const String TITLE_COVID = 'Vacuna PDF';
  static const String KEY_COVID = "Vacuna PDF";

  // CONTROL MEDICO
  static const String TITLE_CONTROL_MEDICO = 'Control Medico';
  static const String KEY_CONTROL_MEDICO = "CONTROL_MEDICO";

  // EMO
  static const String TITLE_EMO = 'EMO';


  static final List<String> titleListGeneral = [
    '1. Posición correcta del documento',
  ];

  static final List<String> imgListDocumentFirst = [
    'assets/documento_cara.png',
  ];

  static final List<String> imgListDocumentSecond = [
    'assets/documento_reverso.png',
  ];

  static final List<String> imgListVacuum = [
    'assets/certificado_vacuna.png',
  ];

  static final List<String> imgListPaseMedicoFirst = [
    'assets/pase_medico_cara.png'
  ];

  static final List<String> imgListPaseMedicoSecond = [
    'assets/pase_medico_reverso.png'
  ];

  static final List<String> imgListControlMedico = [
    'assets/control_medico.png'
  ];

  static final List<String> imgListCovid = [
    'assets/covid.png'
  ];

}