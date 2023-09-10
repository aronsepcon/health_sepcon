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
  static const String COVID = "COVID";

  // VACUNA
  static const String TITLE_CERTIFICADO_VACUNA = 'Certificado de Vacunas';
  static const String KEY_CERTIFICADO_VACUNA = "CERTIFICADO_VACUNA";

  // PASE MEDICO
  static const String TITLE_PASE_MEDICO = "Pase Medico";
  static const String KEY_PASE_MEDICO = "PASE_MEDICO";
  static const int PASE_MEDICO_FIRST_PAGE = 1;
  static const int PASE_MEDICO_SECOND_PAGE = 2;

  // COVID
  static const String TITLE_COVID = 'Covid';
  static const String KEY_COVID = "COVID";

  // CONTROL MEDICO
  static const String TITLE_CONTROL_MEDICO = 'Control Medico';
  static const String KEY_CONTROL_MEDICO = "CONTROL_MEDICO";

  static final List<String> imgListDocumentFirst = [
    'assets/document/document_frontal_0.png',
    'assets/document/document_frontal_4.png',
  ];
  static final List<String> titleListDocumentFirst = [
    '1. Posición correcta del documento',
    '2. Empezar a tomar la foto',
  ];

  static final List<String> imgListDocumentSecond = [
    'assets/document/document_reverso_0.png',
    'assets/document/document_frontal_4.png',
  ];
  static final List<String> titleListDocumentSecond = [
    '1. Posición correcta del documento',
    '2. Empezar a tomar la foto',
  ];

  static final List<String> imgListVacuum = [
    'assets/vaccine/vacuna_1.png',
    'assets/document/document_frontal_4.png',
  ];
  static final List<String> titleListVacuum = [
    '1. Posición correcta del documento',
    '2. Empezar a tomar la foto',
  ];
}