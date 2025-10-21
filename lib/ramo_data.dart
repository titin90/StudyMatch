// Estructura de un Ramo
class Ramo {
  final String code;
  final String name;
  final String careerId;
  final String year;
  final String semester;
  final int credits;

  const Ramo({
    required this.code,
    required this.name,
    required this.careerId,
    required this.year,
    required this.semester,
    this.credits = 5,
  });
}

// Malla Curricular de Ingeniería Civil Informática
final List<Ramo> civilInformaticaRamos = [
  const Ramo(
    code: 'IWI-131',
    name: 'Programación',
    careerId: 'INF',
    year: '1',
    semester: 'I',
    credits: 4,
  ),
  const Ramo(
    code: 'MAT-021',
    name: 'Matemáticas I',
    careerId: 'INF',
    year: '1',
    semester: 'I',
    credits: 5,
  ),
  const Ramo(
    code: 'FIS-100',
    name: 'Introducción a la Física',
    careerId: 'INF',
    year: '1',
    semester: 'I',
    credits: 4,
  ),
  const Ramo(
    code: 'INF-134',
    name: 'Estructuras de Datos',
    careerId: 'INF',
    year: '2',
    semester: 'III',
    credits: 5,
  ),
  const Ramo(
    code: 'INF-239',
    name: 'Bases de Datos',
    careerId: 'INF',
    year: '3',
    semester: 'V',
    credits: 5,
  ),
];

// Malla Curricular de Ingeniería Civil Industrial
final List<Ramo> civilIndustrialRamos = [
  // --- AÑO 1 ---
  const Ramo(
    code: 'INF-100',
    name: 'Informática General',
    careerId: 'IND',
    year: '1',
    semester: 'I',
    credits: 3,
  ),
  const Ramo(
    code: 'MAT-021',
    name: 'Matemáticas I',
    careerId: 'IND',
    year: '1',
    semester: 'I',
    credits: 5,
  ),
  const Ramo(
    code: 'IND-101',
    name: 'Introducción Industrial',
    careerId: 'IND',
    year: '1',
    semester: 'I',
    credits: 4,
  ),
  const Ramo(
    code: 'ECA-100',
    name: 'Contabilidad Básica',
    careerId: 'IND',
    year: '1',
    semester: 'II',
    credits: 4,
  ),
  const Ramo(
    code: 'MAT-022',
    name: 'Matemáticas II',
    careerId: 'IND',
    year: '1',
    semester: 'II',
    credits: 5,
  ),

  // --- AÑO 2 ---
  const Ramo(
    code: 'IND-203',
    name: 'Ingeniería de Procesos',
    careerId: 'IND',
    year: '2',
    semester: 'III',
    credits: 5,
  ),
  const Ramo(
    code: 'MAT-205',
    name: 'Estadística Industrial',
    careerId: 'IND',
    year: '2',
    semester: 'III',
    credits: 5,
  ),
  const Ramo(
    code: 'FIN-201',
    name: 'Finanzas I',
    careerId: 'IND',
    year: '2',
    semester: 'IV',
    credits: 4,
  ),
];

// Lista consolidada de todos los ramos
final List<Ramo> allRamos = [
  ...civilInformaticaRamos,
  ...civilIndustrialRamos,
];
