class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =25;
  static const int DOCUMENT_FIRST = 1 ;
  static const int DOCUMENT_SECOND = 2 ;
  static const int VACUNA_INIT = 3;
  static const int VACUNA_HOME = 4;
  static const String DOCUMENT_IDENTIDAD = "DOCUMENT_IDENTIDAD";
  static const String DOCUMENT_VACUUM = "DOCUMENT_VACUUM";
  static const String COVID = "COVID";

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

}