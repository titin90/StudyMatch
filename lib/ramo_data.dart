import 'package:flutter/material.dart'; // Solo si usas constructores const que lo requieren

/// Define la estructura de un Ramo curricular, AHORA con ID de carrera.
class Ramo {
  final String code;
  final String name;
  final String careerId; // 💡 NUEVO: ID de la Carrera (Ej: 'INF', 'IND')
  final String year; // Año en que se cursa (para agrupar)
  final String semester; // Semestre (I, II, III, etc.)
  final int credits;

  const Ramo({
    required this.code,
    required this.name,
    required this.careerId, // Requerido para el filtrado
    required this.year,
    required this.semester,
    this.credits = 5, // Valor por defecto, si no se especifica
  });
}

// =========================================================================
// Malla Curricular de Ingeniería Civil Informática (ID: 'INF')
// =========================================================================
final List<Ramo> civilInformaticaRamos = [
  // --- AÑO 1 ---
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
  // ... (otros ramos INF)

  // Aquí se simplifica el resto de la lista de INF para mantener el enfoque en la corrección
  // 💡 NOTA: DEBES AÑADIR careerId: 'INF' A CADA RAMO EXISTENTE EN TU LISTA.

  // --- EJEMPLOS DE AÑO 2-3 (Asegúrate de que tus datos originales tengan 'careerId: 'INF') ---
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

// =========================================================================
// Malla Curricular de Ingeniería Civil Industrial (ID: 'IND')
// (Ramos simulados para la demostración)
// =========================================================================
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

// =========================================================================
// Lista consolidada de todos los ramos
// 💡 Usamos esta lista para que la pantalla de selección pueda filtrar
// =========================================================================
final List<Ramo> allRamos = [
  ...civilInformaticaRamos,
  ...civilIndustrialRamos,
  // ... Añade aquí otras listas de ramos (COM, ARQ, etc.)
];
