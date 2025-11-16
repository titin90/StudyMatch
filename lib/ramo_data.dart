// Estructura de un Ramo
class Ramo {
  final String code;
  final String name;
  final String universityId; // Ej: 'USM', 'UC', 'UCHILE', 'USACH'
  final String careerId; // Ej: 'USM-CIV-INF', 'UC-INF'
  final String year;
  final String semester;
  final int credits;

  const Ramo({
    required this.code,
    required this.name,
    required this.universityId,
    required this.careerId,
    required this.year,
    required this.semester,
    this.credits = 5,
  });
}

// ========================================
// UNIVERSIDAD TÉCNICA FEDERICO SANTA MARÍA
// ========================================

// Ingeniería Civil Informática - USM
final List<Ramo> usmCivilInformaticaRamos = [
  // Semestre 1
  const Ramo(
    code: 'ICI-101',
    name: 'Introducción a la Programación',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-102',
    name: 'Algebra y Geometría',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-103',
    name: 'Introducción al Cálculo',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-104',
    name: 'Introducción a la Física',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-105',
    name: 'Comunicación efectiva en español / inglés I',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-106',
    name: 'Educación Física I',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  // Semestre 2
  const Ramo(
    code: 'ICI-201',
    name: 'Proyecto Inicial',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-202',
    name: 'Algebra Lineal',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-203',
    name: 'Cálculo en una Variable',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-204',
    name: 'Física General Mecânica',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-205',
    name: 'Comunicación efectiva en español / inglés II',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-206',
    name: 'Educación Fisica II',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  // Semestre 3
  const Ramo(
    code: 'ICI-301',
    name: 'Programación Avanzada',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-302',
    name: 'Matemática Discreta',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-303',
    name: 'Cálculo en Varias Variables',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-304',
    name: 'Calor y Ondas',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-305',
    name: 'Análisis Crítico de Texto',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-306',
    name: 'Administración & Sostenibilidad Organizacional',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  // Semestre 4
  const Ramo(
    code: 'ICI-401',
    name: 'Estructura de Datos',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-402',
    name: 'Estadistica Computacional',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-403',
    name: 'Ecuaciones Diferenciales Elementales',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-404',
    name: 'Electricidad y Magnetismo',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-405',
    name: 'Comunicación efectiva en español / inglés III',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-406',
    name: 'Ingeniería Económica',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  // Semestre 5
  const Ramo(
    code: 'ICI-501',
    name: 'Bases de Datos',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-502',
    name: 'Optimización',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-503',
    name: 'Arquitectura y Organización de Computadores',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-504',
    name: 'Paradigmas de Programación',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-505',
    name: 'Ingeniería, Informática y Sociedad',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-506',
    name: 'Teoría de Autómatas y Lenguajes Formales',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  // Semestre 6
  const Ramo(
    code: 'ICI-601',
    name: 'Comunicación efectiva en español / inglés IV',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-602',
    name: 'Algoritmos y Complejidad',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-603',
    name: 'Sistemas Operativos',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-604',
    name: 'Análisis y Diseño de Software',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-605',
    name: 'Computación Científica',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-606',
    name: 'Investigación de Operaciones',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-607',
    name: 'PRÁCTICA I',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  // Semestre 7
  const Ramo(
    code: 'ICI-701',
    name: 'Inglés Disciplinar',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-702',
    name: 'Teoria de Sistemas',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-703',
    name: 'Redes y Ciberseguridad',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-704',
    name: 'Ingeniería de Software',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-705',
    name: 'Inteligencia Artificial I',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-706',
    name: 'Fundamentos de Ciencia de Datos',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  // Semestre 8
  const Ramo(
    code: 'ICI-801',
    name: 'Proyecto de Ingeniería',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-802',
    name: 'Sistemas Distribuidos',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-803',
    name: 'Diseño de Experiencia Usuaria',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-804',
    name: 'Sistemas para la Gestión Organizacional',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-805',
    name: 'Inteligencia Artificial II',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-806',
    name: 'PRÁCTICA II',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  // Semestre 9
  const Ramo(
    code: 'ICI-901',
    name: 'Gestión de Proyectos de Informática',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  // Semestre 10
  const Ramo(
    code: 'ICI-1001',
    name: 'Taller de Desarrollo de Proyectos de Informática',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'ICI-1002',
    name: 'Taller Complementario de Titulación',
    universityId: 'USM',
    careerId: 'USM-CIV-INF',
    year: '5',
    semester: '10',
    credits: 0,
  ),
];

// Ingeniería Civil Industrial - USM
final List<Ramo> usmCivilIndustrialRamos = [
  // Semestre 1
  const Ramo(
    code: 'IND-101',
    name: 'Comunicación efectiva en español/inglés i', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-102',
    name: 'Educación Física I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-103',
    name: 'Proyecto Inicial', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-104',
    name: 'Introducción a la Física', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-105',
    name: 'Introducción al Calculo', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-106',
    name: 'Algebra y Geometria', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  // Semestre 2
  const Ramo(
    code: 'IND-201',
    name: 'Comunicación efectiva en español/inglés II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-202',
    name: 'Educación Física II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-203',
    name: 'Introducción a la Programación', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-204',
    name: 'Física General Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-205',
    name: 'Cálculo en una Variable', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-206',
    name: 'Algebra Lineal', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  // Semestre 3
  const Ramo(
    code: 'IND-301',
    name: 'Análisis Critico de Texto', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-302',
    name: 'Administración y Sostenibilidad Organizacional', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-303',
    name: 'Taller de Ingenieria Industrial I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-304',
    name: 'Calor y Ondas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-305',
    name: 'Química Industrial', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-306',
    name: 'Cálculo en Varias Variables', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  // Semestre 4
  const Ramo(
    code: 'IND-401',
    name: 'Comunicación efectiva en español/inglés III', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-402',
    name: 'Ingeniería Económica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-403',
    name: 'Información y Control Financiero', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-404',
    name: 'Electricidad y Magnetismo', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-405',
    name: 'Probabilidad y Estadística', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-406',
    name: 'Ecuaciones Diferenciales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  // Semestre 5
  const Ramo(
    code: 'IND-501',
    name: 'Comunicación efectiva en español/inglés IV', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-502',
    name: 'Investigación de Operaciones', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-503',
    name: 'Taller de Ingenieria Industrial II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-504',
    name: 'Gestión de personas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-505',
    name: 'Procesos industriales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-506',
    name: 'Termodinámica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  // Semestre 6
  const Ramo(
    code: 'IND-601',
    name: 'Taller de Responsabilidad Social y Ética', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-602',
    name: 'Sistemas de Información', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-603',
    name: 'Microeconomía', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-604',
    name: 'Ingenieria de Plantas Industriales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-605',
    name: 'Finanzas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-606',
    name: 'PRÁCTICA I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  // Semestre 7
  const Ramo(
    code: 'IND-701',
    name: 'Inglés Disciplinar', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-702',
    name: 'Evaluación de Proyectos Generales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-703',
    name: 'Marketing', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-704',
    name: 'Gestión Energética', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-705',
    name: 'Macroeconomia', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-706',
    name: 'Econometria', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  // Semestre 8
  const Ramo(
    code: 'IND-801',
    name: 'Electrotecnia Básica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-802',
    name: 'Gestión de la Innovación', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-803',
    name: 'Proyecto de Ingeniería Industrial', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-804',
    name: 'Inteligencia de Negocios', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-805',
    name: 'Organización Industrial', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-806',
    name: 'Gestión de Operaciones I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  // Semestre 9
  const Ramo(
    code: 'IND-901',
    name: 'Gestión de Calidad Total', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-902',
    name: 'Gestión de Operaciones II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-903',
    name: 'Análisis de Negocios', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-904',
    name: 'Gestión Energética y Sustentabilidad', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-905',
    name: 'PRÁCTICA II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-906',
    name: 'Taller de Titula', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  // Semestre 10
  const Ramo(
    code: 'IND-1001',
    name: 'Gestión del Emprendimiento', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '10', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-1002',
    name: 'Desarrollo y Control de Proyectos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '10', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-1003',
    name: 'Gestión Estratégica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '10', // 
    credits: 0,
  ),
  const Ramo(
    code: 'IND-1004',
    name: 'Taller de Titulo II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-IND',
    year: '5',
    semester: '10', // 
    credits: 0,
  ),
];

// Ingeniería Civil Eléctrica - USM
final List<Ramo> usmCivilElectricaRamos = [
  // Semestre 1
  const Ramo(
    code: 'ELE-101',
    name: 'Comunicación efectiva en español / inglés I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-102',
    name: 'Educación Física I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-103',
    name: 'Proyecto Inicial', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-104',
    name: 'Algebra y Geometría', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-105',
    name: 'Introducción al Cálculo', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-106',
    name: 'Introducción a la Física', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  // Semestre 2
  const Ramo(
    code: 'ELE-201',
    name: 'Comunicación efectiva en español / inglés II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-202',
    name: 'Educación Física II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-203',
    name: 'Introducción a la Programación', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-204',
    name: 'Algebra Lineal', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-205',
    name: 'Cálculo en una Variable', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-206',
    name: 'Física General Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  // Semestre 3
  const Ramo(
    code: 'ELE-301',
    name: 'Análisis Crítico de Texto', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-302',
    name: 'Circuitos Eléctricos I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-303',
    name: 'Elementos de Mecánica y Resistencia de Materiales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-304',
    name: 'Ecuaciones Diferenciales Elementales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-305',
    name: 'Cálculo en Varias Variables', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-306',
    name: 'Electricidad y Magnetismo', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  // Semestre 4
  const Ramo(
    code: 'ELE-401',
    name: 'Comunicación efectiva en español / inglés III', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-402',
    name: 'Circuitos Eléctricos II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-403',
    name: 'Estadística Computacional', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-404',
    name: 'Teoría Electromagnética', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-405',
    name: 'Sistemas Dinámicos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-406',
    name: 'Calor y Ondas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  // Semestre 5
  const Ramo(
    code: 'ELE-501',
    name: 'Práctica en Acción Comunitaria', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-502',
    name: 'Administración y Sostenibilidad Organizacional', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-503',
    name: 'Fundamentos de Calor y Fluidos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-504',
    name: 'Control Automático de Sistemas Eléctricos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-505',
    name: 'Electrónica General', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-506',
    name: 'Modelación de Equipamiento Eléctrico', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  // Semestre 6
  const Ramo(
    code: 'ELE-601',
    name: 'Comunicación efectiva en español / inglés IV', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-602',
    name: 'Economía I-A', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-603',
    name: 'Laboratorio de Circuitos Eléctricos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-604',
    name: 'Electrónica de Potencia', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-605',
    name: 'Fundamentos de Máquinas Eléctricas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-606',
    name: 'Simulación Computacional', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-607',
    name: 'PRÁCTICA I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  // Semestre 7
  const Ramo(
    code: 'ELE-701',
    name: 'Inglés Disciplinar', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-702',
    name: 'Ingeniería Económica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-703',
    name: 'Investigación de Operaciones', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-704',
    name: 'Alta Tensión', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-705',
    name: 'Máquinas y Accionamientos Eléctricos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-706',
    name: 'Sistemas de Energía y Potencia', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  // Semestre 8
  const Ramo(
    code: 'ELE-801',
    name: 'Taller de Ingeniería', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-802',
    name: 'Gestión de Proyectos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-803',
    name: 'Ingeniería de Plantas Industriales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-804',
    name: 'Laboratorio de Alta Tensión', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-805',
    name: 'Laboratorio de Máquinas y Accionamientos Eléctricos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-806',
    name: 'Sistemas de Distribución de Energía Eléctrica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  // Semestre 9
  const Ramo(
    code: 'ELE-901',
    name: 'Gestión de la Innovación y Emprendimiento', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-902',
    name: 'Proyectos Eléctricos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-903',
    name: 'Integración de Energías Renovables', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-904',
    name: 'Regulación y Mercado del Sector Eléctrico', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-905',
    name: 'Operación y Control de Sistemas Eléctricos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'ELE-906',
    name: 'PRÁCTICA II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  // Semestre 10
  const Ramo(
    code: 'ELE-1001',
    name: 'Proyecto de Título', // 
    universityId: 'USM',
    careerId: 'USM-CIV-ELE',
    year: '5',
    semester: '10', // 
    credits: 0,
  ),
];

// Ingeniería Civil Mecánica - USM
final List<Ramo> usmCivilMecanicaRamos = [
  // Semestre 1
  const Ramo(
    code: 'MEC-101',
    name: 'Comunicación efectiva en español/Inglés I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-102',
    name: 'Educación Física I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-103',
    name: 'Proyecto Inicial de Ingeniería Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-104',
    name: 'Introducción a la Física', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-105',
    name: 'Introducción al Cálculo', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-106',
    name: 'Algebra & Geometria', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '1', // 
    credits: 0,
  ),
  // Semestre 2
  const Ramo(
    code: 'MEC-201',
    name: 'Comunicación efectiva en español/Inglés II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-202',
    name: 'Educación Física II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-203',
    name: 'Introducción a la Programación', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-204',
    name: 'Física General Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-205',
    name: 'Cálculo en una Variable', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-206',
    name: 'Algebra Lineal', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-207',
    name: 'Química para Ingenieria', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '1',
    semester: '2', // 
    credits: 0,
  ),
  // Semestre 3
  const Ramo(
    code: 'MEC-301',
    name: 'Análisis Critico de Texto', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-302',
    name: 'Estática', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-303',
    name: 'Gráfica de Sistemas Mecânicos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-304',
    name: 'Mecánica de Materiales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-305',
    name: 'Cálculo en Varias Variables', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-306',
    name: 'Ecuaciones Diferenciales', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '3', // 
    credits: 0,
  ),
  // Semestre 4
  const Ramo(
    code: 'MEC-401',
    name: 'Comunicación efectiva en español/Inglés III', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-402',
    name: 'Análisis Numérico', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-403',
    name: 'Dinámica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-404',
    name: 'Materiales para Ingeniería', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-405',
    name: 'Electricidad y Magnetismo', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-406',
    name: 'Administración y Sostenibilidad Organizacional', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '2',
    semester: '4', // 
    credits: 0,
  ),
  // Semestre 5
  const Ramo(
    code: 'MEC-501',
    name: 'Probabilidades y Estadística', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-502',
    name: 'Termodinámica I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-503',
    name: 'Elementos de Sistemas Mecánicos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-504',
    name: 'Elementos de Máquinas I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-505',
    name: 'Tecnologias de Fabricación', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-506',
    name: 'Ingeniería Económica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '5', // 
    credits: 0,
  ),
  // Semestre 6
  const Ramo(
    code: 'MEC-601',
    name: 'Comunicación efectiva en español/Inglés IV', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-602',
    name: 'Mecánica de Fluidos I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-603',
    name: 'Termodinámica II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-604',
    name: 'Procesos de Manufactura', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-605',
    name: 'Elementos de Máquinas II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-606',
    name: 'Mecánica de Máquinas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-607',
    name: 'PRÁCTICA I', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '3',
    semester: '6', // 
    credits: 0,
  ),
  // Semestre 7
  const Ramo(
    code: 'MEC-701',
    name: 'Inglés Disciplinar', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-702',
    name: 'Computación en Ingeniería Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-703',
    name: 'Mecânica de Fluidos II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-704',
    name: 'Transferencia de Calor para Ingeniería', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-705',
    name: 'Turbomáquinas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-706',
    name: 'Ingeniería Ambiental', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '7', // 
    credits: 0,
  ),
  // Semestre 8
  const Ramo(
    code: 'MEC-801',
    name: 'Diseño Mecánico (*)', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-802',
    name: 'Automatización y Control', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-803',
    name: 'Sistemas Autónomos y Mecatrónica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-804',
    name: 'Electrotecnia Básica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-805',
    name: 'Mantenimiento y Gestión de Activos', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-806',
    name: 'Ingeniería Térmica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '4',
    semester: '8', // 
    credits: 0,
  ),
  // Semestre 9
  const Ramo(
    code: 'MEC-901',
    name: 'Proyectos de Ingenieria Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-902',
    name: 'Taller de Innovación y Emprendimiento en Ingeniería Mecánica', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-903',
    name: 'Tecnologías Energéticas', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  const Ramo(
    code: 'MEC-904',
    name: 'PRÁCTICA II', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '5',
    semester: '9', // 
    credits: 0,
  ),
  // Semestre 10
  const Ramo(
    code: 'MEC-1001',
    name: 'Actividad de Titulación(**)', // 
    universityId: 'USM',
    careerId: 'USM-CIV-MEC',
    year: '5',
    semester: '10', // 
    credits: 0,
  ),
];



// ========================================
// PONTIFICIA UNIVERSIDAD CATÓLICA
// ========================================

// Ingeniería Civil Informática - UC
final List<Ramo> ucCienciaComputacionRamos = [
  // Semestre 1
  const Ramo(
    code: 'UC-101',
    name: 'Introducción a la Programación',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-102',
    name: 'Algoritmos y Sistemas Computacionales',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-103',
    name: 'Introducción al Cálculo',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-104',
    name: 'Introducción al Álgebra y Geometría',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-105',
    name: 'Filosofía: ¿Para Qué?',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  // Semestre 2
  const Ramo(
    code: 'UC-201',
    name: 'Matemáticas Discretas',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-202',
    name: 'Programación Avanzada',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-203',
    name: 'Arquitectura de Computadores',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-204',
    name: 'Cálculo I',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  // Semestre 3
  const Ramo(
    code: 'UC-301',
    name: 'Estructuras de Datos y Algoritmos',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-302',
    name: 'Bases de Datos',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-303',
    name: 'Cálculo II',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-304',
    name: 'Álgebra Lineal',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  // Semestre 4
  const Ramo(
    code: 'UC-401',
    name: 'Modelos Probabilísticos',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-402',
    name: 'Ingeniería de Software',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-403',
    name: 'Autómatas y Compiladores',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-404',
    name: 'Sistemas Operativos y Redes',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  // Semestre 5
  const Ramo(
    code: 'UC-501',
    name: 'Fundamentos de Lenguajes de Programación',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-502',
    name: 'Teoría de la Computación',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-503',
    name: 'Tecnologías y Aplicaciones Web',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  // Semestre 6
  const Ramo(
    code: 'UC-601',
    name: 'Inteligencia Artificial',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-602',
    name: 'Diseño y Análisis de Algoritmos',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-603',
    name: 'Seguridad Computacional',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-604',
    name: 'Ética para Cs de la Computación',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  // Semestre 7
  const Ramo(
    code: 'UC-701',
    name: 'Sistemas Distribuidos',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-702',
    name: 'Interfaces y Experiencia de Usuario',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'UC-703',
    name: 'Práctica de Ciencia de la Computación',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  // Semestre 8
  const Ramo(
    code: 'UC-801',
    name: 'Proyecto de Innovación y Computación',
    universityId: 'UC',
    careerId: 'UC-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
];

// Derecho - UC
final List<Ramo> ucDerechoRamos = [
  // Semestre 1
  const Ramo(
    code: 'DER001F',
    name: 'DERECHO ROMANO I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '1',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER003F',
    name: 'FUNDAMENTOS FILOSÓFICOS DEL DERECHO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '1',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER005F',
    name: 'HISTORIA DEL DERECHO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '1',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER007F',
    name: 'TEORIA Y FUENTES DEL DERECHO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '1',
    credits: 5, // 
  ),
  const Ramo(
    code: 'EAE105A',
    name: 'INTRODUCCIÓN A LA ECONOMIA',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '1',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER100H',
    name: 'TALLER DE METODOLOGÍA DE LA INVESTIGACIÓN',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '1',
    credits: 0, // 
  ),

  // Semestre 2
  const Ramo(
    code: 'DER002F',
    name: 'DERECHO ROMANO II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '2',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER004F',
    name: 'DERECHO NATURAL',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '2',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER006F',
    name: 'HISTORIA DE LAS INSTITUCIONES JURID, POL Y SOCIALES CHILENAS',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '2',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER009F',
    name: 'DERECHO POLÍTICO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '2',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER008F',
    name: 'DERECHO ECONOMICO I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '1',
    semester: '2',
    credits: 5, // 
  ),

  // Semestre 3
  const Ramo(
    code: 'DER001C',
    name: 'TEORÍA DEL ACTO JURÍDICO Y TEORÍA DE LA LEY',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '3',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER001L',
    name: 'INSTITUCIONES DEL ESTADO DE DERECHO CHILENO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '3',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER0021', // El código parece ser DER002I
    name: 'DERECHO INTERNACIONAL PÚBLICO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '3',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER006L',
    name: 'DERECHO ECONÓMICO II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '3',
    credits: 10, // 
  ),

  // Semestre 4
  const Ramo(
    code: 'DER002C',
    name: 'PERSONAS Y BIENES',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '4',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER001R',
    name: 'INSTITUCIONES PROCESALES I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '4',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER003L',
    name: 'DERECHOS FUNDAMENTALES Y DERECHOS HUMANOS',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '4',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER001S',
    name: 'DERECHO DEL TRABAJO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '4',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER008C',
    name: 'EL COMERCIANTE Y BASES CONT MERCANTIL',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '2',
    semester: '4',
    credits: 10, // 
  ),

  // Semestre 5
  const Ramo(
    code: 'DER003C',
    name: 'OBLIGACIONES',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '5',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER002R',
    name: 'INSTITUCIONES PROCESALES II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '5',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER004L',
    name: 'DERECHO ADMINISTRATIVO I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '5',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER001P',
    name: 'DERECHO PENAL PARTE GENERAL I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '5',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER010C',
    name: 'FINANCIAMIENTO DE LA EMPRESA',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '5',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER009C',
    name: 'DERECHO DE SOCIEDADES',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '5',
    credits: 10, // 
  ),

  // Semestre 6
  const Ramo(
    code: 'DER004C',
    name: 'FUENTES DE OBLIGACIONES I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER005C',
    name: 'FUENTES DE LAS OBLIGACIONES II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER003R',
    name: 'PROCEDIMIENTOS CIVILES I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER004R',
    name: 'PROCEDIMIENTOS CIVILES II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER005L',
    name: 'DERECHO ADMINISTRATIVO II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER002P',
    name: 'DERECHO PENAL PARTE GENERAL II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER003P',
    name: 'DERECHO PENAL PARTE ESPECIAL',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '3',
    semester: '6',
    credits: 10, // 
  ),

  // Semestre 7
  // (La columna del Semestre 7 solo contenía "FORMACIÓN GENERAL") 

  // Semestre 8
  const Ramo(
    code: 'DER006C',
    name: 'DERECHO DE FAMILIA',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER007C',
    name: 'DERECHO SUCESORIO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER90X',
    name: 'ÉTICA PROFESIONAL',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER005R',
    name: 'PROCEDIMIENTOS PENALES',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER002N',
    name: 'DERECHO CANONICO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER011C',
    name: 'CONTRATOS MERCANTILES Y CONCURSOS',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER007L',
    name: 'DERECHO TRIBUTARIO I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER30XH',
    name: 'CLÍNICA JURIDICA I',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '4',
    semester: '8',
    credits: 10, // 
  ),

  // Semestre 9
  // (La columna del Semestre 9 estaba vacía) 

  // Semestre 10
  const Ramo(
    code: 'DER0120', // El código parece ser DER012O
    name: 'DERECHO INTERNACIONAL PRIVADO',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '5',
    semester: '10',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER008L',
    name: 'DERECHO TRIBUTARIO II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '5',
    semester: '10',
    credits: 5, // 
  ),
  const Ramo(
    code: 'DER20XH',
    name: 'SEMINARIO DE INVESTIGACIÓN',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '5',
    semester: '10',
    credits: 10, // 
  ),
  const Ramo(
    code: 'DER40XH',
    name: 'CLÍNICA JURÍDICA II',
    universityId: 'UC',
    careerId: 'UC-DER',
    year: '5',
    semester: '10',
    credits: 10, // 
  ),
];

// Ingeniería Civil - UC
final List<Ramo> ucIngenieriaCivRamos = [
  // Semestre 1
  const Ramo(
    code: 'MAT1610',
    name: 'CÁLCULO I', // [cite: 85]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 10, // [cite: 89]
  ),
  const Ramo(
    code: 'QIM100E',
    name: 'QUÍMICA PARA INGENIERÍA', // [cite: 101, 103]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 10, // [cite: 104]
  ),
  const Ramo(
    code: 'MAT1203',
    name: 'ALGEBRA LINEAL', // [cite: 116]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 10, // [cite: 120]
  ),
  const Ramo(
    code: 'IC1103',
    name: 'INTRODUCCIÓN A LA PROGRAMACIÓN', // [cite: 154, 155]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 10, // [cite: 157]
  ),
  const Ramo(
    code: 'FIL2001',
    name: 'FILOSOFÍA: ¿PARA QUÉ?', // [cite: 163, 164]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 10, // [cite: 168]
  ),
  const Ramo(
    code: 'VRA100C',
    name: 'ESPAÑOL', // [cite: 173]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 0, // [cite: 175]
  ),
  const Ramo(
    code: 'VRA4000',
    name: 'INTEGRIDAD ACADÉMICA EN LA UC', // [cite: 201, 202]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '1', // [cite: 77]
    credits: 0, // [cite: 204]
  ),

  // Semestre 2
  const Ramo(
    code: 'MAT1620',
    name: 'CÁLCULO II', // [cite: 86]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '2', // [cite: 78]
    credits: 10, // [cite: 91]
  ),
  const Ramo(
    code: 'FIS1514/ICE1514',
    name: 'DINAMICA', // [cite: 102]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '2', // [cite: 78]
    credits: 10, // [cite: 105]
  ),
  const Ramo(
    code: 'FIS1533',
    name: 'ELECTRICIDAD Y MAGNETISMO', // [cite: 107]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '2', // [cite: 78]
    credits: 10, // [cite: 114]
  ),
  const Ramo(
    code: 'ING1004',
    name: 'DESAFIOS DE LA INGENIERÍA', // [cite: 122, 124]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '2', // [cite: 78]
    credits: 10, // [cite: 126]
  ),
  const Ramo(
    code: 'VRA3010',
    name: 'ENGLISH TEST', // [cite: 193]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '1',
    semester: '2', // [cite: 78]
    credits: 0, // [cite: 195]
  ),

  // Semestre 3 (Asumiendo que es el segundo "SEMESTRE II" )
  const Ramo(
    code: 'MAT1630',
    name: 'CÁLCULO III', // [cite: 87]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '3', // 
    credits: 10, // [cite: 93]
  ),
  const Ramo(
    code: 'FIS1523/IIQ1003',
    name: 'TERMODINAMICA', // [cite: 100]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '3', // 
    credits: 10, // [cite: 106]
  ),
  const Ramo(
    code: 'FIS0154',
    name: 'LABORATORIO DE DINÁMICA', // [cite: 117, 118]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '3', // 
    credits: 0, // (No se especifican créditos en la casilla [cite: 121])
  ),
  const Ramo(
    code: 'ICS1513',
    name: 'INTRODUCCIÓN A LA ECONOMÍA', // [cite: 123, 125]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '3', // 
    credits: 10, // [cite: 128]
  ),
  const Ramo(
    code: 'FIS0152',
    name: 'LABORATORIO DE TERMODINAMICA', // [cite: 142, 143]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '3', // 
    credits: 0, // [cite: 150]
  ),
  const Ramo(
    code: 'MAT1640',
    name: 'ECUACIONES DIFERENCIALES', // [cite: 159]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '3', // 
    credits: 10, // [cite: 161]
  ),

  // Semestre 4
  const Ramo(
    code: 'EYP1113',
    name: 'PROBABILIDADES Y ESTADÍSTICA', // [cite: 94]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '4', // [cite: 80]
    credits: 10, // [cite: 99]
  ),
  const Ramo(
    code: 'Q103H',
    name: 'TERMODINAMICA HONORS', // [cite: 129]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '4', // [cite: 80]
    credits: 10, // [cite: 134]
  ),
  const Ramo(
    code: 'FIS0153',
    name: 'LABORATORIO DE ELECTRICIDAD Y MAGNETISMO', // [cite: 143, 144, 145]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '2',
    semester: '4', // [cite: 80]
    credits: 0, // [cite: 151]
  ),

  // Semestre 5
  const Ramo(
    code: 'IEE1533',
    name: 'TEORÍA ELECTROMAGNÉTICA', // [cite: 131]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '3',
    semester: '5', // [cite: 81]
    credits: 10, // [cite: 136]
  ),
  const Ramo(
    code: 'ING1001',
    name: 'PRÁCTICA I', // [cite: 196]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '3',
    semester: '5', // [cite: 81]
    credits: 0, // [cite: 198]
  ),

  // Semestre 6
  const Ramo(
    code: 'ING2030',
    name: 'INVESTIGACIÓN, INNOVACIÓN Y EMPRENDIMIENTO', // [cite: 137]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '3',
    semester: '6', // [cite: 82]
    credits: 10, // [cite: 141]
  ),

  // Semestre 7
  // (Vacío después de filtrar Cursos Major/Minor/Formación) [cite: 83]

  // Semestre 8
  const Ramo(
    code: 'EXC-001', // (Código no especificado en el PDF [cite: 199, 200])
    name: 'EX. DE COMP. FUND', // [cite: 199]
    universityId: 'UC',
    careerId: 'UC-CIV',
    year: '4',
    semester: '8', // [cite: 84]
    credits: 0, // [cite: 200]
  ),
];

// Medicina - UC
final List<Ramo> ucMedicinaRamos = [
  // Semestre 1
  const Ramo(
    code: 'MED107A',
    name: 'BASES Y FUNDAMENTOS DE LA MEDICINA I',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '1', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'QIM201M',
    name: 'QUÍMICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '1', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'MED109A',
    name: 'PSICOLOGÍA MEDICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '1', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'FIS119M',
    name: 'FISICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '1', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'MAT1033',
    name: 'RAZONAMIENTO MATEMÁTICO',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '1', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'VRA4000',
    name: 'INTEGRIDAD ACADÉMICA EN LA UC',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '1', // 
    credits: 0, // 
  ),

  // Semestre 2
  const Ramo(
    code: 'MED108A',
    name: 'BASES Y FUNDAMENTOS DE LA MEDICINA II',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '2', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'MED111A',
    name: 'INMUNOLOGIA Y GENETICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '2', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'BIO239M',
    name: 'BIOLOGIA MOLECULAR DE LA CELULA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '2', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED1048', // (El código en el PDF es MED1048)
    name: 'BIOESTADISTICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '2', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'MED110A',
    name: 'INTEGRADO CIENCIAS MEDICAS I',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '1',
    semester: '2', // 
    credits: 5, // 
  ),

  // Semestre 3
  const Ramo(
    code: 'MED208A',
    name: 'MORFOLOGIA I',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '3', // 
    credits: 6, // 
  ),
  const Ramo(
    code: 'MED207A',
    name: 'ANTROPOLOGÍA Y ÉTICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '3', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'MED206A',
    name: 'SALUD PUBLICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '3', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'MED209A',
    name: 'INTEGRADO CIENCIAS MEDICAS II',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '3', // 
    credits: 10, // 
  ),

  // Semestre 4
  const Ramo(
    code: 'MED212A',
    name: 'MORFOLOGIA II',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '4', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED3068', // (El código en el PDF es MED3068)
    name: 'MICROBIOLOGIA MEDICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '4', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'MED214A',
    name: 'BASES Y MENCANISMOS DE LA ENFERMEDAD I',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '4', // 
    credits: 30, // 
  ),
  const Ramo(
    code: 'MED210A',
    name: 'INTEGRADO CIENCIAS MEDICAS III',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '2',
    semester: '4', // 
    credits: 5, // 
  ),

  // Semestre 5
  const Ramo(
    code: 'MED213A',
    name: 'MORFOLOGIA III',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '5', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED3078', // (El código en el PDF es MED3078)
    name: 'FARMACOLOGIA MEDICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '5', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'MED310B',
    name: 'BASES Y MECANISMOS DE LA ENFERMEDAD II',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '5', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED311A',
    name: 'INTEGRADO CIENCIAS MEDICAS IV',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '5', // 
    credits: 10, // 
  ),

  // Semestre 6
  const Ramo(
    code: 'MED308A',
    name: 'CLÍNICA I',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '6', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED408A',
    name: 'NEUROCIENCIAS',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '6', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED312A',
    name: 'INTEGRADO CIENCIAS MEDICAS V',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '3',
    semester: '6', // 
    credits: 5, // 
  ),

  // Semestre 7
  const Ramo(
    code: 'MED309A',
    name: 'CLÍNICA II',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '4',
    semester: '7', // 
    credits: 40, // 
  ),
  const Ramo(
    code: 'MED405A',
    name: 'INTEGRADO CIENCIAS MEDICAS VI',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '4',
    semester: '7', // 
    credits: 5, // 
  ),

  // Semestre 8
  const Ramo(
    code: 'MED404A',
    name: 'CLINICA III',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '4',
    semester: '8', // 
    credits: 40, // 
  ),
  const Ramo(
    code: 'MED406A',
    name: 'INTEGRADO CIENCIAS MEDICAS VII',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '4',
    semester: '8', // 
    credits: 5, // 
  ),

  // Semestre 9
  const Ramo(
    code: 'MED407A',
    name: 'INTEGRADO QUIRÚRGICO',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '5',
    semester: '9', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED409A',
    name: 'MEDICINA ADULTO',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '5',
    semester: '9', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED508A',
    name: 'BASES DE LA PRÁCTICA PROFESIONAL',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '5',
    semester: '9', // 
    credits: 10, // 
  ),
  const Ramo(
    code: 'MED509A',
    name: 'INTEGRADO CIENCIAS MEDICAS VIII',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '5',
    semester: '9', // 
    credits: 5, // 
  ),

  // Semestre 10
  const Ramo(
    code: 'MED504B',
    name: 'PEDIATRIA Y CIRUGÍA INFANTIL',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '5',
    semester: '10', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED505B',
    name: 'OBSTETRICIA Y GINECOLOGIA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '5',
    semester: '10', // 
    credits: 15, // 
  ),

  // Semestre 11
  const Ramo(
    code: 'MED601B',
    name: 'INTERNADO DE CIRUGÍA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '11', // 
    credits: 25, // 
  ),
  const Ramo(
    code: 'MED602B', // (El PDF indica MED6028 , asumo MED602B por consistencia)
    name: 'INTERNADO DE MEDICINA INTERNA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '11', // 
    credits: 25, // 
  ),
  const Ramo(
    code: 'MED606A',
    name: 'INTERNADO DE URGENCIAS',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '11', // 
    credits: 15, // 
  ),
  const Ramo(
    code: 'MED607A',
    name: 'INTERNADO DE OTORRINOLARINGOLOGÍA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '11', // 
    credits: 5, // 
  ),
  const Ramo(
    code: 'MED609A',
    name: 'INTERNADO DE DERMATOLOGIA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '11', // 
    credits: 5, // 
  ),

  // Semestre 12
  const Ramo(
    code: 'MED603B',
    name: 'INTERNADO MEDICINA FAMILIAR',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '12', // 
    credits: 20, // 
  ),
  const Ramo(
    code: 'MED604B',
    name: 'INTERNADO DE PEDIATRIA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '12', // 
    credits: 25, // 
  ),
  const Ramo(
    code: 'MED605A',
    name: 'INTERNADO DE OBSTETRICIA Y GINECOLOGIA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '12', // 
    credits: 25, // 
  ),
  const Ramo(
    code: 'MED608A',
    name: 'INTERNADO DE NEUROPSIQUIATRIA CLÍNICA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '12', // 
    credits: 20, // 
  ),
  const Ramo(
    code: 'MED611A',
    name: 'INTERNADO DE OFTALMOLOGIA',
    universityId: 'UC',
    careerId: 'UC-MED',
    year: '6',
    semester: '12', // 
    credits: 5, // 
  ),
];



// ========================================
// UNIVERSIDAD DE CHILE
// ========================================

// Ingeniería Civil Informática - UChile
final List<Ramo> uChileIngenieriaCivilComputacionRamos = [
  // Semestre 1
  const Ramo(
    code: 'MA1001',
    name: 'INTRODUCCIÓN AL CÁLCULO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'MA1101',
    name: 'INTRODUCCIÓN AL ÁLGEBRA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'FI1000',
    name: 'INTRODUCCIÓN A LA FÍSICA CLÁSICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'CC1000',
    name: 'HERRAMIENTAS COMPUTACIONALES PARA INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '1',
    credits: 3,
  ),
  const Ramo(
    code: 'CD1100',
    name: 'DESAFÍOS DE INNOVACIÓN EN INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'BT1211',
    name: 'APLICACIONES DE LA BIOLOGÍA A LA INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '1',
    credits: 3,
  ),

  // Semestre 2
  const Ramo(
    code: 'MA1002',
    name: 'CÁLCULO DIFERENCIAL E INTEGRAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'MA1102',
    name: 'ÁLGEBRA LINEAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'FI1100',
    name: 'INTRODUCCIÓN A LA FÍSICA MODERNA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'CC1002',
    name: 'INTRODUCCIÓN A LA PROGRAMACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'CD1201',
    name: 'PROYECTO DE INNOVACIÓN EN INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '1',
    semester: '2',
    credits: 3,
  ),

  // Semestre 3
  const Ramo(
    code: 'MA2001',
    name: 'CÁLCULO EN VARIAS VARIABLES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'MA2601',
    name: 'ECUACIONES DIFERENCIALES ORDINARIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2003',
    name: 'MÉTODOS EXPERIMENTALES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2001',
    name: 'MECÁNICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'IQ2211',
    name: 'QUÍMICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '3',
    credits: 6,
  ),

  // Semestre 4
  const Ramo(
    code: 'IN2201',
    name: 'ECONOMÍA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'MA2002',
    name: 'CÁLCULO AVANZADO Y APLICACIONES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2002',
    name: 'ELECTROMAGNETISMO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2004/IQ2212',
    name: 'TERMODINÁMICA / TERMODINÁMICA QUÍMICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'CD2201',
    name: 'MÓDULO INTERDISCIPLINARIO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '2',
    semester: '4',
    credits: 3,
  ),

  // Semestre 5
  const Ramo(
    code: 'MA3403',
    name: 'PROBABILIDADES Y ESTADÍSTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'CC3501',
    name: 'MODELACIÓN Y COMPUTACIÓN GRÁFICA PARA INGENIEROS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'CC3001',
    name: 'ALGORITMOS Y ESTRUCTURAS DE DATOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'CC3101',
    name: 'MATEMÁTICAS DISCRETAS PARA LA COMPUTACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '5',
    credits: 6,
  ),

  // Semestre 6
  const Ramo(
    code: 'CC3201',
    name: 'BASES DE DATOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'CC3002',
    name: 'METODOLOGÍAS DE DISEÑO Y PROGRAMACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'CC3102',
    name: 'TEORÍA DE LA COMPUTACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'CC3301',
    name: 'PROGRAMACIÓN DE SOFTWARE DE SISTEMAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '3',
    semester: '6',
    credits: 6,
  ),

  // Semestre 7
  const Ramo(
    code: 'CC5205',
    name: 'MINERÍA DE DATOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'CC4401',
    name: 'INGENIERÍA DE SOFTWARE',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'CC4102',
    name: 'DISEÑO Y ANÁLISIS DE ALGORITMOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'CC4302',
    name: 'SISTEMAS OPERATIVOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'CC4901',
    name: 'PRÁCTICA PROFESIONAL I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '7',
    credits: 7,
  ),

  // Semestre 8
  const Ramo(
    code: 'CC4402',
    name: 'FORMULACIÓN, EVALUACIÓN Y GESTIÓN DE PROYECTOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'CC4101',
    name: 'LENGUAJES DE PROGRAMACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'CC4303',
    name: 'REDES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'EI1090',
    name: 'EXAMEN DE SUFICIENCIA EN INGLÉS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '4',
    semester: '8',
    credits: 0,
  ),

  // Semestre 9
  const Ramo(
    code: 'CC5901',
    name: 'PRÁCTICA PROFESIONAL II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '5',
    semester: '9',
    credits: 7,
  ),

  // Semestre 10
  const Ramo(
    code: 'CC5402',
    name: 'PROYECTO DE SOFTWARE',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '5',
    semester: '10',
    credits: 12,
  ),
  const Ramo(
    code: 'CC6907',
    name: 'INTRODUCCIÓN AL TRABAJO DE TÍTULO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '5',
    semester: '10',
    credits: 6,
  ),

  // Semestre 11
  const Ramo(
    code: 'CC6919',
    name: 'TRABAJO DE TÍTULO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '6',
    semester: '11',
    credits: 24,
  ),
  const Ramo(
    code: 'EI2090',
    name: 'EXAMEN DE SUFICIENCIA EN INGLÉS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-COMP',
    year: '6',
    semester: '11',
    credits: 0,
  ),
];

// Ingeniería Civil Industrial - UChile
final List<Ramo> uChileIngenieriaCivilIndustrialRamos = [
  // Semestre 1
  const Ramo(
    code: 'MA1001',
    name: 'INTRODUCCIÓN AL CÁLCULO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'MA1101',
    name: 'INTRODUCCIÓN AL ÁLGEBRA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'FI1000',
    name: 'INTRODUCCIÓN A LA FÍSICA CLÁSICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'CC1000',
    name: 'HERRAMIENTAS COMPUTACIONALES PARA INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '1',
    credits: 3,
  ),
  const Ramo(
    code: 'CD1100',
    name: 'DESAFÍOS DE INNOVACIÓN EN INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'BT1211',
    name: 'APLICACIONES DE LA BIOLOGÍA A LA INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '1',
    credits: 3,
  ),

  // Semestre 2
  const Ramo(
    code: 'MA1002',
    name: 'CÁLCULO DIFERENCIAL E INTEGRAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'MA1102',
    name: 'ÁLGEBRA LINEAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'FI1100',
    name: 'INTRODUCCIÓN A LA FÍSICA MODERNA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'CC1002',
    name: 'INTRODUCCIÓN A LA PROGRAMACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'CD1201',
    name: 'PROYECTO DE INNOVACIÓN EN INGENIERÍA Y CIENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '1',
    semester: '2',
    credits: 3,
  ),

  // Semestre 3
  const Ramo(
    code: 'MA2001',
    name: 'CÁLCULO EN VARIAS VARIABLES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'MA2601',
    name: 'ECUACIONES DIFERENCIALES ORDINARIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2003',
    name: 'MÉTODOS EXPERIMENTALES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2001',
    name: 'MECÁNICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'IQ2211',
    name: 'QUÍMICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '3',
    credits: 6,
  ),

  // Semestre 4
  const Ramo(
    code: 'IN2201',
    name: 'ECONOMÍA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'MA2002',
    name: 'CÁLCULO AVANZADO Y APLICACIONES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2002',
    name: 'ELECTROMAGNETISMO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'FI2004/IQ2212',
    name: 'TERMODINÁMICA / TERMODINÁMICA QUÍMICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'CD2201',
    name: 'MÓDULO INTERDISCIPLINARIO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '2',
    semester: '4',
    credits: 3,
  ),

  // Semestre 5
  const Ramo(
    code: 'IN3171',
    name: 'MODELAMIENTO Y OPTIMIZACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'IN3101',
    name: 'TALLER DE LIDERAZGO E INNOVACIÓN SOCIAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'IN3141',
    name: 'PROBABILIDADES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '5',
    credits: 6,
  ),

  // Semestre 6
  const Ramo(
    code: 'IN3272',
    name: 'DECISIONES BAJO INCERTIDUMBRE',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'IN3221',
    name: 'TEORÍA DE JUEGOS Y ESTRATEGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'IN3242',
    name: 'ESTADÍSTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'IN3301',
    name: 'EVALUACIÓN DE PROYECTOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '3',
    semester: '6',
    credits: 6,
  ),

  // Semestre 7
  const Ramo(
    code: 'IN4102',
    name: 'TALLER DE CONCEPCIÓN Y DISEÑO DE PROYECTOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'IN4123',
    name: 'MACROECONOMÍA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'IN4143',
    name: 'ANÁLISIS DE DATOS E INFERENCIA CAUSAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'IN4151',
    name: 'INGENIERÍA DE LA INFORMACIÓN',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'IN4191',
    name: 'PRÁCTICA PROFESIONAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '7',
    credits: 7,
  ),

  // Semestre 8
  const Ramo(
    code: 'IN4273',
    name: 'GESTIÓN DE OPERACIONES',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'IN4261',
    name: 'MARKETING',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'IN4232',
    name: 'FINANZAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'EI1090',
    name: 'EXAMEN DE SUFICIENCIA EN INGLÉS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '4',
    semester: '8',
    credits: 0,
  ),

  // Semestre 9
  const Ramo(
    code: 'IN5112',
    name: 'DIRECCIÓN ESTRATÉGICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '5',
    semester: '9',
    credits: 6,
  ),
  const Ramo(
    code: 'IN5111',
    name: 'COMPORTAMIENTO ORGANIZACIONAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '5',
    semester: '9',
    credits: 6,
  ),

  // Semestre 10
  // (Vacío después de filtrar electivos y especialización)

  // Semestre 11
  const Ramo(
    code: 'IN6193',
    name: 'PROYECTO DE TÍTULO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '6',
    semester: '11',
    credits: 15,
  ),
  const Ramo(
    code: 'IN6192',
    name: 'PRÁCTICA PROFESIONAL EXTENDIDA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '6',
    semester: '11',
    credits: 15,
  ),
  const Ramo(
    code: 'EI2090',
    name: 'EXAMEN DE SUFICIENCIA EN INGLÉS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-CIV-IND',
    year: '6',
    semester: '11',
    credits: 0,
  ),
];

// Ingeniería Comercial - UChile
final List<Ramo> uChileIngenieriaComercialRamos = [
  // Semestre 1
  const Ramo(
    code: 'COM-101',
    name: 'GESTION Y EMPRESA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-102',
    name: 'INTRODUCCION A LA ECONOMIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-103',
    name: 'METODOS MATEMATICOS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-104',
    name: 'TECNOLOGIA Y SISTEMAS DE INFORMACION',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 4,
  ),
  const Ramo(
    code: 'COM-105',
    name: 'COMUNICACION ESTRATEGICA Y CRITICA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-106',
    name: 'IDIOMAS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-107',
    name: 'INTRODUCCION AL PENSAMIENTO ECONOMICO Y POLITICO',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '1',
    credits: 2,
  ),

  // Semestre 2
  const Ramo(
    code: 'COM-201',
    name: 'GESTION DE PERSONAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-202',
    name: 'MICROECONOMIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-203',
    name: 'METODOS MATEMATICOS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-204',
    name: 'INTRODUCCION ESTADISTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-205',
    name: 'COMUNICACION ESTRATEGICA Y CRITICA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-206',
    name: 'IDIOMAS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-207',
    name: 'INTRODUCCION AL PENSAMIENTO ECONOMICO Y POLITICO II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '1',
    semester: '2',
    credits: 2,
  ),

  // Semestre 3
  const Ramo(
    code: 'COM-301',
    name: 'MARKETING',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-302',
    name: 'MACROECONOMIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-303',
    name: 'METODOS MATEMATICOS III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-304',
    name: 'CONTABILIDAD',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '3',
    credits: 4,
  ),
  const Ramo(
    code: 'COM-305',
    name: 'COMUNICACION ESTRATEGICA Y CRITICA III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '3',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-306',
    name: 'IDIOMAS III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '3',
    credits: 2,
  ),

  // Semestre 4
  const Ramo(
    code: 'COM-401',
    name: 'FINANZAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-402',
    name: 'ECONOMIA POLÍTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-403',
    name: 'TALLER DE POLÍTICA PÚBLICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-404',
    name: 'TEORIA ESTADISTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-405',
    name: 'METODOS MATEMATICOS AVANZADOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-406',
    name: 'ANALISIS DE DATOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-407',
    name: 'CONTABILIDAD EMPRESARIAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-408',
    name: 'TALLER DE NEGOCIOS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 2,
  ),
  const Ramo(
    code: 'COM-409',
    name: 'IDIOMAS IV',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '2',
    semester: '4',
    credits: 2,
  ),

  // --- INICIO MENCIONES (AÑO 3) ---

  // Semestre 5 (Mención Economía)
  const Ramo(
    code: 'COM-501E',
    name: 'MICROECONOMIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-502E',
    name: 'MACROECONOMIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-503E',
    name: 'METODOS CUANTITATIVOS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-504E',
    name: 'HISTORIA ECONOMICA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),

  // Semestre 5 (Mención Administración)
  const Ramo(
    code: 'COM-501A',
    name: 'NEGOCIOS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-502A',
    name: 'GESTION DE PERSONAS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-503A',
    name: 'ECONOMIA PARA LOS NEGOCIOS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-504A',
    name: 'TALLER PRACTICO PROFESIONAL I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '5',
    credits: 6,
  ),

  // Semestre 6 (Mención Economía)
  const Ramo(
    code: 'COM-601E',
    name: 'MICROECONOMIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-602E',
    name: 'MACROECONOMIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-603E',
    name: 'METODOS CUANTITATIVOS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-604E',
    name: 'HISTORIA ECONOMICA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),

  // Semestre 6 (Mención Administración)
  const Ramo(
    code: 'COM-601A',
    name: 'NEGOCIOS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-602A',
    name: 'GESTION DE PERSONAS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-603A',
    name: 'ECONOMIA PARA LOS NEGOCIOS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-604A',
    name: 'TALLER PRACTICO PROFESIONAL II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '3',
    semester: '6',
    credits: 6,
  ),

  // --- INICIO AÑO 4 ---

  // Semestre 7 (Mención Economía)
  const Ramo(
    code: 'COM-701E',
    name: 'MICROECONOMIA III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-702E',
    name: 'MACROECONOMIA III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-703E',
    name: 'METODOS CUANTITATIVOS III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-704E',
    name: 'NEGOCIOS PARA ECONOMIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),

  // Semestre 7 (Mención Administración)
  const Ramo(
    code: 'COM-701A',
    name: 'FINANZAS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-702A',
    name: 'MARKETING I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-703A',
    name: 'TALLER PRACTICO PROFESIONAL III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '7',
    credits: 6,
  ),

  // Semestre 8 (Mención Economía)
  const Ramo(
    code: 'COM-801E',
    name: 'MICROECONOMIA IV',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-802E',
    name: 'MACROECONOMIA IV',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-803E',
    name: 'METODOS CUANTITATIVOS IV',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-804E',
    name: 'NEGOCIOS PARA ECONOMIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '8',
    credits: 6,
  ),

  // Semestre 8 (Mención Administración)
  const Ramo(
    code: 'COM-801A',
    name: 'FINANZAS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '8',
    credits: 6,
  ),
  const Ramo(
    code: 'COM-802A',
    name: 'MARKETING II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '4',
    semester: '8',
    credits: 6,
  ),

  // --- AÑO 5 (Actividad Profesional de Cierre) ---
  // (Asignados a Semestre 9 por ser "IX, X")
  const Ramo(
    code: 'COM-901',
    name: 'PRACTICA PROFESIONAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '5',
    semester: '9',
    credits: 36,
  ),
  const Ramo(
    code: 'COM-902',
    name: 'TALLER DE PRACTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-COM',
    year: '5',
    semester: '9',
    credits: 12,
  ),
];

// Medicina - UChile
final List<Ramo> uChileMedicinaRamos = [
  // Nivel I (Primer Año)
  // Semestre 1
  const Ramo(
    code: 'MED-101',
    name: 'MATEMATICAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '1',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-102',
    name: 'QUIMICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-103',
    name: 'ANATOMIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-104',
    name: 'INTRODUCCION A LA PROFESION MEDICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '1',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-105',
    name: 'MEDICINA Y SOCIEDAD',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '1',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-106',
    name: 'INGLES I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '1',
    credits: 3,
  ),
  // Semestre 2
  const Ramo(
    code: 'MED-201',
    name: 'FISICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 5,
  ),
  const Ramo(
    code: 'MED-202',
    name: 'BIOLOGIA CELULAR Y MOLECULAR',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-203',
    name: 'ANATOMIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-204',
    name: 'HISTOLOGIA Y EMBRIOLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-205',
    name: 'MEDICINA PERSONAL Y SOCIEDAD',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-206',
    name: 'INTRODUCCION A LA SALUD PUBLICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-207',
    name: 'INGLES II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '1',
    semester: '2',
    credits: 3,
  ),

  // Nivel II (Segundo Año)
  // Semestre 3
  const Ramo(
    code: 'MED-301',
    name: 'FISIOLOGIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 8,
  ),
  const Ramo(
    code: 'MED-302',
    name: 'BIOQUIMICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-303',
    name: 'GENETICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 5,
  ),
  const Ramo(
    code: 'MED-304',
    name: 'UNIDAD DE INVESTIGACION I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-305',
    name: 'SEMIOLOGIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-306',
    name: 'BIOETICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-307',
    name: 'BIOESTADISTICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '3',
    credits: 2,
  ),
  // Semestre 4
  const Ramo(
    code: 'MED-401',
    name: 'FISIOLOGIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '4',
    credits: 8,
  ),
  const Ramo(
    code: 'MED-402',
    name: 'INMUNOLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '4',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-403',
    name: 'MEDICINA EVOLUTIVA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '4',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-404',
    name: 'UNIDAD DE INVESTIGACION II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '4',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-405',
    name: 'SEMIOLOGIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '4',
    credits: 9,
  ),
  const Ramo(
    code: 'MED-406',
    name: 'CASOS INTEGRADORES I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '2',
    semester: '4',
    credits: 3,
  ),

  // Nivel III (Tercer Año)
  // Semestre 5
  const Ramo(
    code: 'MED-501',
    name: 'FISIOPATOLOGIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-502',
    name: 'FARMACOLOGIA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-503',
    name: 'AGENTES VIVOS DE LA ENFERMEDAD I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-504',
    name: 'MEDICINA INTERNA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 9,
  ),
  const Ramo(
    code: 'MED-505',
    name: 'ETICA CLINICA I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-506',
    name: 'EPIDEMIOLOGIA DESCRIPTIVA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-507',
    name: 'MODULO INTEGRADO INTERDISCIPLINARIO MULTIPROFESIONAL I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '5',
    credits: 4,
  ),
  // Semestre 6
  const Ramo(
    code: 'MED-601',
    name: 'FISIOPATOLOGIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '6',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-602',
    name: 'FARMACOLOGIA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '6',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-603',
    name: 'AGENTES VIVOS DE LA ENFERMEDAD II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '6',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-604',
    name: 'MEDICINA INTERNA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '6',
    credits: 14,
  ),
  const Ramo(
    code: 'MED-605',
    name: 'EPIDEMIOLOGIA ANALITICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '6',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-606',
    name: 'CASOS INTEGRADORES II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '3',
    semester: '6',
    credits: 2,
  ),

  // Nivel IV (Cuarto Año)
  // Semestre 7
  const Ramo(
    code: 'MED-701',
    name: 'MEDICINA GENERAL FAMILIAR I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '7',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-702',
    name: 'CIRUGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '7',
    credits: 9,
  ),
  const Ramo(
    code: 'MED-703',
    name: 'GERIATRIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '7',
    credits: 5,
  ),
  const Ramo(
    code: 'MED-704',
    name: 'ANATOMIA PATOLOGICA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '7',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-705',
    name: 'ETICA CLINICA II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '7',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-706',
    name: 'CASOS INTEGRADORES III',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '7',
    credits: 3,
  ),
  // Semestre 8
  const Ramo(
    code: 'MED-801',
    name: 'MEDICINA GENERAL FAMILIAR II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '8',
    credits: 9,
  ),
  const Ramo(
    code: 'MED-802',
    name: 'ESPECIALIDADES MEDICAS Y QUIRURGICAS I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '8',
    credits: 8,
  ),
  const Ramo(
    code: 'MED-803',
    name: 'NEUROLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '8',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-804',
    name: 'MEDICINA LEGAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '8',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-805',
    name: 'DIAGNOSTICO DE SITUACION DE SALUD',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '8',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-806',
    name: 'SEGURIDAD SOCIAL Y ATENCION DE SALUD',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '4',
    semester: '8',
    credits: 2,
  ),

  // Nivel V (Quinto Año)
  // Semestre 9
  const Ramo(
    code: 'MED-901',
    name: 'PEDIATRIA Y CIRUGIA INFANTIL (2)',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '9',
    credits: 10,
  ),
  const Ramo(
    code: 'MED-902',
    name: 'ESPECIALIDADES MEDICAS Y QUIRURGICAS II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '9',
    credits: 8,
  ),
  const Ramo(
    code: 'MED-903',
    name: 'MEDICINA DE URGENCIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '9',
    credits: 4,
  ),
  const Ramo(
    code: 'MED-904',
    name: 'GESTION I',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '9',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-905',
    name: 'CASOS INTEGRADORES IV',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '9',
    credits: 3,
  ),
  // Semestre 10
  const Ramo(
    code: 'MED-1001',
    name: 'GINECOLOGIA-OBSTETRICIA (2)',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '10',
    credits: 10,
  ),
  const Ramo(
    code: 'MED-1002',
    name: 'PSIQUIATRIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '10',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-1003',
    name: 'PSIQUIATRIA INFANTIL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '10',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-1004',
    name: 'GESTION II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '10',
    credits: 2,
  ),
  const Ramo(
    code: 'MED-1005',
    name: 'MODULO INTEGRADO INTERDISCIPLINARIO MULTIPROFESIONAL II',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '5',
    semester: '10',
    credits: 5,
  ),

  // Nivel VI (Sexto Año)
  // Semestre 11 (Anual XI - XII)
  const Ramo(
    code: 'MED-1101',
    name: 'INTERNADO MEDICINA INTERNA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 26,
  ),
  const Ramo(
    code: 'MED-1102',
    name: 'INTERNADO PEDIATRIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 26,
  ),
  const Ramo(
    code: 'MED-1103',
    name: 'INTERNADO UROLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-1104',
    name: 'INTERNADO OFTALMOLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-1105',
    name: 'INTERNADO OTORRINOLARINGOLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-1106',
    name: 'INTERNADO DERMATOLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 3,
  ),
  const Ramo(
    code: 'MED-1107',
    name: 'INTERNADO TRAUMATOLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-1108',
    name: 'INTERNADO URGENCIAS',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '6',
    semester: '11',
    credits: 6,
  ),

  // Nivel VII (Septimo Año)
  // Semestre 13 (Anual XIII - XIV)
  const Ramo(
    code: 'MED-1301',
    name: 'INTERNADO CIRUGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '7',
    semester: '13',
    credits: 18,
  ),
  const Ramo(
    code: 'MED-1302',
    name: 'INTERNADO GINECOLOGIA - OBSTETRICIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '7',
    semester: '13',
    credits: 18,
  ),
  const Ramo(
    code: 'MED-1303',
    name: 'INTERNADO ATENCION PRIMARIA URBANA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '7',
    semester: '13',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-1304',
    name: 'INTERNADO ATENCION PRIMARIA RURAL',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '7',
    semester: '13',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-1305',
    name: 'INTERNADO NEUROLOGIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '7',
    semester: '13',
    credits: 6,
  ),
  const Ramo(
    code: 'MED-1306',
    name: 'INTERNADO PSIQUIATRIA',
    universityId: 'UCHILE',
    careerId: 'UCHILE-MED',
    year: '7',
    semester: '13',
    credits: 6,
  ),
];

// ========================================
// UNIVERSIDAD DE SANTIAGO
// ========================================

// Ingeniería Civil Informática - USACH
final List<Ramo> usachInformaticaRamos = [
  // Semestre 1
  const Ramo(
    code: 'INF-101',
    name: 'Cálculo I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-102',
    name: 'Álgebra I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-103',
    name: 'Física I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-104',
    name: 'Ingeniería y Sostenibilidad',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-105',
    name: 'Introducción al Diseño en Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '1',
    credits: 0,
  ),

  // Semestre 2
  const Ramo(
    code: 'INF-201',
    name: 'Cálculo II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-202',
    name: 'Álgebra II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-203',
    name: 'Física II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-204',
    name: 'Introducción a la Ingeniería Informática',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-205',
    name: 'Fundamentos de Programación para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-206',
    name: 'Fundamentos de Computación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '1',
    semester: '2',
    credits: 0,
  ),

  // Semestre 3
  const Ramo(
    code: 'INF-301',
    name: 'Cálculo III para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-302',
    name: 'Estructura de Datos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-303',
    name: 'Electricidad, Magnetismo y Ondas',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-304',
    name: 'Diseño de Algoritmos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-305',
    name: 'Fundamentos de Economía para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-306',
    name: 'Inglés I',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '3',
    credits: 0,
  ),

  // Semestre 4
  const Ramo(
    code: 'INF-401',
    name: 'Ecuaciones Diferenciales y Métodos Numéricos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-402',
    name: 'Diseño de Bases de Datos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-403',
    name: 'Arquitectura de Computadores',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-404',
    name: 'Paradigmas de Programación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-405',
    name: 'Taller de Diseño en Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-406',
    name: 'Inglés II',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '2',
    semester: '4',
    credits: 0,
  ),

  // Semestre 5
  const Ramo(
    code: 'INF-501',
    name: 'Estadística Computacional',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-502',
    name: 'Teoría de la Computación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-503',
    name: 'Sistemas Operativos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-504',
    name: 'Fundamentos de Ingeniería de Software',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-505',
    name: 'Taller de Programación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-506',
    name: 'Inglés III',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '5',
    credits: 0,
  ),

  // Semestre 6
  const Ramo(
    code: 'INF-601',
    name: 'Estadística Inferencial',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-602',
    name: 'Bases de Datos Avanzadas',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-603',
    name: 'Procesamiento de Señales e Imágenes',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-604',
    name: 'Técnicas de Ingeniería de Software',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-605',
    name: 'Evaluación de Proyectos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-606',
    name: 'Inglés IV',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '3',
    semester: '6',
    credits: 0,
  ),

  // Semestre 7
  const Ramo(
    code: 'INF-701',
    name: 'Modelos y Simulación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-702',
    name: 'Métodos de Optimización',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-703',
    name: 'Redes de Comunicación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-704',
    name: 'Gestión de Proyectos TI',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-705',
    name: 'Innovación y Emprendimiento',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-706',
    name: 'Formación Integral I',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '7',
    credits: 0,
  ),

  // Semestre 8
  const Ramo(
    code: 'INF-801',
    name: 'Análisis de Datos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-802',
    name: 'Ciberseguridad',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-803',
    name: 'Sistemas Distribuidos y Paralelos',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-804',
    name: 'Gestión de Servicios TI',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-805',
    name: 'Proyecto de Ingeniería de Software',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-806',
    name: 'Formación Integral II',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '4',
    semester: '8',
    credits: 0,
  ),

  // Semestre 9
  const Ramo(
    code: 'INF-901',
    name: 'Aprendizaje Automático',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-902',
    name: 'Tópico de Especialidad I',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-903',
    name: 'Tópico de Especialidad II',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-904',
    name: 'Gobernanza y Gestión TI',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '9',
    credits: 0,
  ),

  // Semestre 10
  const Ramo(
    code: 'INF-1001',
    name: 'Seminario de Informática',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-1002',
    name: 'Tópico de Especialidad III',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'INF-1003',
    name: 'Tópico de Especialidad IV',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '5',
    semester: '10',
    credits: 0,
  ),

  // Semestre 11
  const Ramo(
    code: 'INF-1101',
    name: 'Trabajo de Titulación',
    universityId: 'USACH',
    careerId: 'USACH-INF',
    year: '6',
    semester: '11',
    credits: 0,
  ),
];

// Ingeniería Civil Industrial - USACH
final List<Ramo> usachIngenieriaCivilIndustrialRamos = [
  // Semestre 1
  const Ramo(
    code: 'IND-101',
    name: 'Cálculo I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-102',
    name: 'Álgebra I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-103',
    name: 'Física I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-104',
    name: 'Introducción a la Ingeniería Industrial',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-105',
    name: 'Introducción al Diseño en la Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '1',
    credits: 0,
  ),

  // Semestre 2
  const Ramo(
    code: 'IND-201',
    name: 'Cálculo II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-202',
    name: 'Álgebra II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-203',
    name: 'Física II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-204',
    name: 'Química General y Termodinámica',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-205',
    name: 'Fundamentos de Programación para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '1',
    semester: '2',
    credits: 0,
  ),

  // Semestre 3
  const Ramo(
    code: 'IND-301',
    name: 'Cálculo III para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-302',
    name: 'Ecuaciones Diferenciales para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-303',
    name: 'Física Moderna',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-304',
    name: 'Programación',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-305',
    name: 'Fundamentos de Economía para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-306',
    name: 'Inglés I',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '3',
    credits: 0,
  ),

  // Semestre 4
  const Ramo(
    code: 'IND-401',
    name: 'Análisis Estadístico para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-402',
    name: 'Métodos Numéricos para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-403',
    name: 'Ingeniería de Sistemas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-404',
    name: 'Diseño Digital Computacional',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-405',
    name: 'Taller de Diseño en Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-406',
    name: 'Inglés II',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '2',
    semester: '4',
    credits: 0,
  ),

  // Semestre 5
  const Ramo(
    code: 'IND-501',
    name: 'Estadística Aplicada',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-502',
    name: 'Operaciones y Procesos Industriales',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-503',
    name: 'Administración',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-504',
    name: 'Microeconomía',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-505',
    name: 'Taller de Gestión y Liderazgo',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-506',
    name: 'Inglés III',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '5',
    credits: 0,
  ),

  // Semestre 6
  const Ramo(
    code: 'IND-601',
    name: 'Macroeconomía',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-602',
    name: 'Contabilidad y Costos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-603',
    name: 'Investigación de Operaciones',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-604',
    name: 'Tecnologías para la Gestión',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-605',
    name: 'Introducción a la Innovación',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-606',
    name: 'Inglés IV',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '3',
    semester: '6',
    credits: 0,
  ),

  // Semestre 7
  const Ramo(
    code: 'IND-701',
    name: 'Diseño de Productos y Sistemas Productivos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-702',
    name: 'Marketing Estratégico',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-703',
    name: 'Modelos Estocásticos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-704',
    name: 'Finanzas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-705',
    name: 'Gestión del Emprendimiento',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '7',
    credits: 0,
  ),

  // Semestre 8
  const Ramo(
    code: 'IND-801',
    name: 'Sistemas de Información',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-802',
    name: 'Análisis de Decisiones',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-803',
    name: 'Modelamiento de Sistemas Complejos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-804',
    name: 'Inteligencia de Negocios',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-805',
    name: 'Evaluación de Proyectos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '4',
    semester: '8',
    credits: 0,
  ),

  // Semestre 9
  const Ramo(
    code: 'IND-901',
    name: 'Tópico de Especialidad I',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-902',
    name: 'Gestión de Personas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-903',
    name: 'Gestión de Producción de Bienes y Servicios',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-904',
    name: 'Gestión Estratégica',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '9',
    credits: 0,
  ),

  // Semestre 10
  const Ramo(
    code: 'IND-1001',
    name: 'Tópico de Especialidad II',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-1002',
    name: 'Proyecto de Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-1003',
    name: 'Gestión de Cadena de Suministro',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'IND-1004',
    name: 'Tópico de Especialidad III',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '5',
    semester: '10',
    credits: 0,
  ),

  // Semestre 11
  const Ramo(
    code: 'IND-1101',
    name: 'Trabajo de Titulación',
    universityId: 'USACH',
    careerId: 'USACH-CIV-IND',
    year: '6',
    semester: '11',
    credits: 0,
  ),
];

// Ingeniería en Comercio Internacional - USACH
final List<Ramo> usachIngenieriaComercialRamos = [
  // Semestre 1
  const Ramo(
    code: 'COM-101',
    name: 'Matemáticas para Administración y Economía I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-102',
    name: 'Taller de Computación',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-103',
    name: 'Introducción a la Economía',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-104',
    name: 'Introducción a la Administración',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-105',
    name: 'Ética y RSE(*)',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-106',
    name: 'Contabilidad General',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-107',
    name: 'Taller de Comunicaciones I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '1',
    credits: 0,
  ),

  // Semestre 2
  const Ramo(
    code: 'COM-201',
    name: 'Matemáticas para Administración y Economía II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-202',
    name: 'Álgebra Lineal',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-203',
    name: 'Principios de Microeconomía',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-204',
    name: 'Teoría Administrativa',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-205',
    name: 'Inglés para la Administración y Economía I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-206',
    name: 'Taller de Comunicaciones II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '1',
    semester: '2',
    credits: 0,
  ),

  // Semestre 3
  const Ramo(
    code: 'COM-301',
    name: 'Matemáticas para Administración y Economía III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-302',
    name: 'Estadísticas para Administración y Economía I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-303',
    name: 'Principios de Macroeconomía',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-304',
    name: 'Derecho y Empresa',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-305',
    name: 'Inglés para la Administración y Economía II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-306',
    name: 'Contabilidad Financiera y Toma de Decisiones',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '3',
    credits: 0,
  ),

  // Semestre 4
  const Ramo(
    code: 'COM-401',
    name: 'Inferencia Estadística para la Administración',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-402',
    name: 'Organización Industrial',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-403',
    name: 'Derecho y Empresa II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-404',
    name: 'Investigación de Operaciones',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-405',
    name: 'Sistema de Costos y Toma de decisiones',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-406',
    name: 'Habilidades para la Organización I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '2',
    semester: '4',
    credits: 0,
  ),

  // Semestre 5
  const Ramo(
    code: 'COM-501',
    name: 'Marketing I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-502',
    name: 'Transformación Digital I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-503',
    name: 'Comportamiento Organizacional',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-504',
    name: 'Inglés para la Administración y Economía III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-505',
    name: 'Gestión de Operaciones',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-506',
    name: 'Finanzas I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-507',
    name: 'Habilidades para la Organización II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '5',
    credits: 0,
  ),

  // Semestre 6
  const Ramo(
    code: 'COM-601',
    name: 'Marketing II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-602',
    name: 'Transformación Digital II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-603',
    name: 'Gestión de Personas I',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-604',
    name: 'Comportamiento Social y Toma de Decisiones',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-605',
    name: 'Finanzas II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-606',
    name: 'Práctica I: Apresto Organizacional',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '3',
    semester: '6',
    credits: 0,
  ),

  // Semestre 7
  const Ramo(
    code: 'COM-701',
    name: 'Marketing III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-702',
    name: 'Transformación Digital III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-703',
    name: 'Gestión de Personas II',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-704',
    name: 'Negocios y Sostenibilidad',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-705',
    name: 'Acción y Sostenibilidad',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-706',
    name: 'Finanzas III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-707',
    name: 'Inglés para la Administración y Economía IV',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '7',
    credits: 0,
  ),

  // Semestre 8
  const Ramo(
    code: 'COM-801',
    name: 'Transformación Digital III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-802',
    name: 'Estrategia de Negocios',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-803',
    name: 'Implementación y Control Estratégico',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-804',
    name: 'Capacidad Emprendedora',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-805',
    name: 'Exámen de Grado',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'COM-806',
    name: 'Habilidades para la Organización III',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '4',
    semester: '8',
    credits: 0,
  ),

  // Semestre 9
  // (Solo Electivos)

  // Semestre 10
  const Ramo(
    code: 'COM-1001',
    name: 'Práctica Profesional',
    universityId: 'USACH',
    careerId: 'USACH-COM',
    year: '5',
    semester: '10',
    credits: 0,
  ),
];

// Ingeniería en Minas - USACH
final List<Ramo> usachIngenieriaCivilMinasRamos = [
  // Semestre 1
  const Ramo(
    code: 'MIN-101',
    name: 'Cálculo I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-102',
    name: 'Álgebra I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-103',
    name: 'Física I para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-104',
    name: 'Química General para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '1',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-105',
    name: 'Introducción al Diseño en Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '1',
    credits: 0,
  ),

  // Semestre 2
  const Ramo(
    code: 'MIN-201',
    name: 'Cálculo II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-202',
    name: 'Álgebra II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-203',
    name: 'Física II para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-204',
    name: 'Análisis Estadístico para Ingeniería en Minas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-205',
    name: 'Fundamentos de Programación para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '2',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-206',
    name: 'Métodos Gráficos para Ingeniería en Minas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '1',
    semester: '2',
    credits: 0,
  ),

  // Semestre 3
  const Ramo(
    code: 'MIN-301',
    name: 'Cálculo III para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-302',
    name: 'Termodinámica y Físico Química',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-303',
    name: 'Electricidad y Electrotecnia',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-304',
    name: 'Geología General y Estructural',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-305',
    name: 'Fundamentos de Economía para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '3',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-306',
    name: 'Inglés I',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '3',
    credits: 0,
  ),

  // Semestre 4
  const Ramo(
    code: 'MIN-401',
    name: 'Métodos de Explotación',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-402',
    name: 'Ecuaciones Diferenciales y Métodos Numéricos para Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-403',
    name: 'Mineralogía y Petrografía',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-404',
    name: 'Mecánica de Fluidos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-405',
    name: 'Taller de Diseño en Ingeniería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '4',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-406',
    name: 'Inglés II',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '2',
    semester: '4',
    credits: 0,
  ),

  // Semestre 5
  const Ramo(
    code: 'MIN-501',
    name: 'Voladura de Rocas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-502',
    name: 'Geomensura de Minas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-503',
    name: 'Geología Económica y de Minas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-504',
    name: 'Resistencia de Materiales',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-505',
    name: 'Ingeniería Económica y Evaluación de Proyectos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '5',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-506',
    name: 'Inglés III',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '5',
    credits: 0,
  ),

  // Semestre 6
  const Ramo(
    code: 'MIN-601',
    name: 'Carguío y Transporte',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-602',
    name: 'Modelación y Simulación',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-603',
    name: 'Procesos Mineralúrgicos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-604',
    name: 'Mecánica de Rocas I',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-605',
    name: 'Administración de Empresas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '6',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-606',
    name: 'Inglés IV',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '3',
    semester: '6',
    credits: 0,
  ),

  // Semestre 7
  const Ramo(
    code: 'MIN-701',
    name: 'Estimación de Recursos Mineros',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-702',
    name: 'Optimización',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-703',
    name: 'Servicios Generales Mina',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-704',
    name: 'Mecánica de Rocas II',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-705',
    name: 'Seguridad Minera y Salud Ocupacional',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '7',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-706',
    name: 'Concentración de Minerales',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '7',
    credits: 0,
  ),

  // Semestre 8
  const Ramo(
    code: 'MIN-801',
    name: 'Ventilación de Minas',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-802',
    name: 'Procesos Metalúrgicos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-803',
    name: 'Economía Minera',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-804',
    name: 'Gestión en las Operaciones Unitarias',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-805',
    name: 'Liderazgo',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '8',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-806',
    name: 'Tecnologías Avanzadas para Minería',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '4',
    semester: '8',
    credits: 0,
  ),

  // Semestre 9
  const Ramo(
    code: 'MIN-901',
    name: 'Tópicos de la Especialidad I',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-902',
    name: 'Administración y Gestión de Proyectos Mineros',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-903',
    name: 'Sustentabilidad Minera',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-904',
    name: 'Diseño y Planificación Mina Cielo Abierto',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '9',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-905',
    name: 'Diseño y Planificación Mina Subterránea',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '9',
    credits: 0,
  ),

  // Semestre 10
  const Ramo(
    code: 'MIN-1001',
    name: 'Tópicos de la Especialidad II',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-1002',
    name: 'Legislación Laboral y Minera',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-1003',
    name: 'Taller de Evaluación de Proyectos Metalúrgicos',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-1004',
    name: 'Taller de Proyecto Mina Cielo Abierto',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '10',
    credits: 0,
  ),
  const Ramo(
    code: 'MIN-1005',
    name: 'Taller de Proyecto Mina Subterránea',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '5',
    semester: '10',
    credits: 0,
  ),

  // Semestre 11
  const Ramo(
    code: 'MIN-1101',
    name: 'Trabajo de Titulación',
    universityId: 'USACH',
    careerId: 'USACH-CIV-MIN',
    year: '6',
    semester: '11',
    credits: 0,
  ),
];

// ========================================
// FUNCIONES HELPER
// ========================================

// Mapa para acceso rápido por careerId
final Map<String, List<Ramo>> ramosByCareer = {
  'USM-CIV-INF': usmCivilInformaticaRamos,
  'USM-CIV-IND': usmCivilIndustrialRamos,
  'USM-CIV-ELE': usmCivilElectricaRamos,
  'USM-CIV-MEC': usmCivilMecanicaRamos,
  'UC-CC': ucCienciaComputacionRamos,
  'UC-DER': ucDerechoRamos,
  'UC-CIV': ucIngenieriaCivRamos,
  'UC-MED': ucMedicinaRamos,
  'UCHILE-CIV-INF': uChileIngenieriaCivilComputacionRamos,
  'UCHILE-CIV-IND': uChileIngenieriaCivilIndustrialRamos,
  'UCHILE-COM': uChileIngenieriaComercialRamos,
  'UCHILE-MED': uChileMedicinaRamos,
  'USACH-CIV-INF': usachInformaticaRamos,
  'USACH-CIV-IND': usachIngenieriaCivilIndustrialRamos,
  'USACH-COM': usachIngenieriaComercialRamos,
  'USACH-CIV-MIN': usachIngenieriaCivilMinasRamos,
};

// Obtener ramos de una carrera específica
List<Ramo> getRamosForCareer(String careerId) {
  return ramosByCareer[careerId] ?? [];
}

// Obtener ramos por año y semestre
List<Ramo> getRamosByYearAndSemester(String careerId, String year, String semester) {
  final allRamos = getRamosForCareer(careerId);
  return allRamos.where((ramo) => ramo.year == year && ramo.semester == semester).toList();
}

// Lista consolidada de todos los ramos (para búsquedas generales)
final List<Ramo> allRamos = [
  ...usmCivilInformaticaRamos,
  ...usmCivilIndustrialRamos,
  ...usmCivilElectricaRamos,
  ...usmCivilMecanicaRamos,
  ...ucCienciaComputacionRamos,
  ...ucDerechoRamos,
  ...ucIngenieriaCivRamos,
  ...ucIngenieriaCivRamos,
  ...ucMedicinaRamos,
  ...uChileIngenieriaCivilComputacionRamos,
  ...uChileIngenieriaCivilIndustrialRamos,
  ...uChileIngenieriaComercialRamos,
  ...uChileMedicinaRamos,
  ...usachInformaticaRamos,
  ...usachIngenieriaCivilIndustrialRamos,
  ...usachIngenieriaComercialRamos,
  ...usachIngenieriaCivilMinasRamos,


];
