//
// final dummyTeachers = {
//   "mkEAOmSVQiQ8jreWnjMAhVKsrko2": {
//       "id": "mkEAOmSVQiQ8jreWnjMAhVKsrko2",
//       "name": "Anjali Mehta",
//       "gender": "Female",
//       "dob": "1990-04-12",
//       "contact": "9876501234",
//       "email": "anjali@school.com",
//       "subjects": ["Math", "Science"],
//       "assignedClasses": ["4A", "4B"],
//       "joiningDate": "2020-06-01",
//       "isActive": true,
//       "profileImageUrl": "https://..."
//   },
//   "t002": {
//     "name": "Ms. Desai",
//     "contact": "9999000002",
//     "assignedClasses": ["1B"]
//   }
// };


final dummyTeachers = {
  "9mGtH3RXGhhkrj1Od4AwvDoZThm2": {
    "id": "9mGtH3RXGhhkrj1Od4AwvDoZThm2",
    "name": "Anjali Mehta",
    "gender": "Female",
    "dob": "1990-04-12",
    "contact": "9876501234",
    "email": "anjali@school.com",
    "subjects": ["Math", "Science"],
    "assignedClasses": ["2B", "4C"],
    "joiningDate": "2020-06-01",
    "isActive": true,
    "profileImageUrl": "https://..."
  },
};

// final dummyClasses = {
//   "1A": {
//     "teacherId": "t001",
//     "students": ["s001", "s002", "s003", "s004", "s005"]
//   },
//   "1B": {
//     "teacherId": "t002",
//     "students": ["s006", "s007", "s008", "s009", "s010"]
//   }
// };

final dummyClasses = {
  "2B": {
    "teacherId": "9mGtH3RXGhhkrj1Od4AwvDoZThm2",
    "students": ["E6aYaavOKWXWRoUDAmu4O26IEc83"]
  },
  "4C": {
    "teacherId": "9mGtH3RXGhhkrj1Od4AwvDoZThm2",
    "students": ["DpcCqrBzOsMQQEHyxE9o4S4c6t83"]
  }
};

// final dummyStudents = {
//   "cVwHb0u0hAPPyGhhoIfD8pqBOPt1": {
//       "name": "Ravi Patel",
//       "rollNo": 3,
//       "contact": "9876543210",
//       "parentContact": "9876500000",
//       "dob": "2017-08-15",
//       "address": "Ahmedabad",
//       "id" :"cVwHb0u0hAPPyGhhoIfD8pqBOPt1",
//       "classHistory": [
//         { "year": "2023", "classId": "1A" },
//         { "year": "2024", "classId": "2B" },
//         { "year": "2025", "classId": "3B" }
//       ],
//
//       "attendance": {
//         "1A": {
//           "2021-07": {
//             "1": "P",
//             "2": "P",
//             "3": "A"
//           }
//         },
//         "2B": {
//           "2022-07": {
//             "1": "P",
//             "2": "A",
//             "3": "P"
//           }
//         },
//         "3B": {
//           "2023-07": {
//             "1": "A",
//             "2": "P",
//             "3": "P"
//           }
//         }
//       },
//
//       "feeStatus": {
//         "1A": {
//           "total": 20000,
//           "paid": 20000,
//           "due": 0
//         },
//         "2B": {
//           "total": 21000,
//           "paid": 21000,
//           "due": 0
//         },
//         "3B": {
//           "total": 22000,
//           "paid": 10000,
//           "due": 12000
//         }
//       }
//
//   },
//   "N89AVnI5PncqNqfe9sdQSbIAIt23": {
//       "name": "Nisha Mehta",
//       "rollNo": 2,
//       "contact": "9888111002",
//       "parentContact": "9888222002",
//       "dob": "2018-06-10",
//       "address": "Surat",
//       "id": "N89AVnI5PncqNqfe9sdQSbIAIt23",
//       "classHistory": [
//         { "year": "2024", "classId": "1A" },
//         { "year": "2025", "classId": "2B" },
//       ],
//
//       "attendance": {
//         "1A": {
//           "2021-07": {
//             "1": "P",
//             "2": "A"
//           }
//         },
//         "2B": {
//           "2022-07": {
//             "1": "P"
//           }
//         },
//         "3B": {
//           "2023-07": {
//             "1": "P",
//             "2": "A"
//           }
//         }
//       },
//
//       "feeStatus": {
//         "1A": {
//           "total": 20000,
//           "paid": 20000,
//           "due": 0
//         },
//         "2B": {
//           "total": 21000,
//           "paid": 10000,
//           "due": 11000
//         },
//         "3B": {
//           "total": 22000,
//           "paid": 0,
//           "due": 22000
//         }
//       }
//   }
// };



// final dummyStudents = {
//   "rCiE6kzZ1Qec58AhamTrVC9Wyv32": {
//     "id": "rCiE6kzZ1Qec58AhamTrVC9Wyv32",
//     "name": "Ravi Patel",
//     "gender": "Male",
//     "dob": "2017-08-15",
//     "contact": "9876543210",
//     "parentContact": "9876500000",
//     "address": "Ahmedabad",
//     "profileImageUrl": "",
//     "admissionDate": "2021-06-15",
//     "classHistory": [
//       { "year": "2023", "classId": "1A" },
//       { "year": "2024", "classId": "2B" },
//       { "year": "2025", "classId": "3B" }
//     ],
//     "classRecords": {
//       "1A": {
//         "rollNo": 3,
//         "attendance": {
//           "2023-07": { "1": "P", "2": "P", "3": "A" }
//         },
//         "feeStatus": { "total": 20000, "paid": 20000, "due": 0 },
//         "feePayments": [
//           { "date": "2023-04-01", "amount": 20000, "mode": "Cash" }
//         ]
//       },
//       "2B": {
//         "rollNo": 4,
//         "attendance": {
//           "2024-07": { "1": "P", "2": "A", "3": "P" }
//         },
//         "feeStatus": { "total": 21000, "paid": 21000, "due": 0 },
//         "feePayments": [
//           { "date": "2024-06-01", "amount": 21000, "mode": "UPI" }
//         ]
//       },
//       "3B": {
//         "rollNo": 5,
//         "attendance": {
//           "2025-07": { "1": "A", "2": "P", "3": "P" }
//         },
//         "feeStatus": { "total": 22000, "paid": 10000, "due": 12000 },
//         "feePayments": [
//           { "date": "2025-07-05", "amount": 10000, "mode": "Cash" }
//         ]
//       }
//     }
//   },
//
//   "J0GXLfrl1ncWBPsrN9ROkHXGl1w1": {
//     "id": "J0GXLfrl1ncWBPsrN9ROkHXGl1w1",
//     "name": "Nisha Mehta",
//     "gender": "Female",
//     "dob": "2018-06-10",
//     "contact": "9888111002",
//     "parentContact": "9888222002",
//     "address": "Surat",
//     "profileImageUrl": "",
//     "admissionDate": "2022-05-12",
//     "classHistory": [
//       { "year": "2024", "classId": "1A" },
//       { "year": "2025", "classId": "2B" }
//     ],
//     "classRecords": {
//       "1A": {
//         "rollNo": 2,
//         "attendance": {
//           "2024-07": { "1": "P", "2": "A", "3": "P" }
//         },
//         "feeStatus": { "total": 20000, "paid": 20000, "due": 0 },
//         "feePayments": [
//           { "date": "2024-04-01", "amount": 20000, "mode": "Cash" }
//         ]
//       },
//       "2B": {
//         "rollNo": 3,
//         "attendance": {
//           "2025-07": { "1": "P", "2": "P", "3": "A" }
//         },
//         "feeStatus": { "total": 21000, "paid": 10000, "due": 11000 },
//         "feePayments": [
//           { "date": "2025-06-10", "amount": 10000, "mode": "Bank Transfer" }
//         ]
//       }
//     }
//   }
// };

final dummyStudents = {
  "E6aYaavOKWXWRoUDAmu4O26IEc83": {
    "id": "E6aYaavOKWXWRoUDAmu4O26IEc83",
    "name": "Ravi Patel",
    "gender": "Male",
    "dob": "2017-08-15",
    "contact": "9876543210",
    "parentContact": "9876500000",
    "address": "Ahmedabad",
    "profileImageUrl": "",
    "admissionDate": "2024-06-15",
    "classHistory": [
      { "year": "2024", "classId": "1A" },
      { "year": "2025", "classId": "2B" }
    ],
    "classRecords": {
      "1A": {
        "rollNo": 1,
        "attendance": {
          "2024-07": { "1": "P", "2": "P", "3": "A", "4": "P", "5": "P" },
          "2024-10": { "1": "A", "2": "P", "3": "A", "4": "P", "5": "P" },
          "2024-12": { "1": "P", "2": "A", "3": "P" }
        },
        "feeStatus": { "total": 21000, "paid": 21000, "due": 0 },
        "feePayments": [
          { "date": "2024-06-20", "amount": 7000, "mode": "UPI" },
          { "date": "2024-08-01", "amount": 7000, "mode": "Cash" },
          { "date": "2024-10-05", "amount": 7000, "mode": "Bank Transfer" }
        ]
      },
      "2B": {
        "rollNo": 2,
        "attendance": {
          "2025-01": { "1": "P", "2": "P", "3": "P", "4": "A", "5": "P" },
          "2025-05": { "1": "P" },
          "2025-06": { "1": "A", "4": "P", "5": "P" }
        },
        "feeStatus": { "total": 22000, "paid": 15000, "due": 7000 },
        "feePayments": [
          { "date": "2025-01-10", "amount": 5000, "mode": "Cash" },
          { "date": "2025-03-15", "amount": 5000, "mode": "UPI" },
          { "date": "2025-05-01", "amount": 5000, "mode": "Bank Transfer" }
        ]
      }
    }
  },

  "DpcCqrBzOsMQQEHyxE9o4S4c6t83": {
    "id": "DpcCqrBzOsMQQEHyxE9o4S4c6t83",
    "name": "Nisha Mehta",
    "gender": "Female",
    "dob": "2018-06-10",
    "contact": "9888111002",
    "parentContact": "9888222002",
    "address": "Surat",
    "profileImageUrl": "",
    "admissionDate": "2024-06-20",
    "classHistory": [
      { "year": "2024", "classId": "3A" },
      { "year": "2025", "classId": "4C" }
    ],
    "classRecords": {
      "3A": {
        "rollNo": 3,
        "attendance": {
          "2024-07": { "1": "A", "2": "P", "3": "P", "4": "P", "5": "A" },
          "2024-12": { "1": "P" }
        },
        "feeStatus": { "total": 20000, "paid": 20000, "due": 0 },
        "feePayments": [
          { "date": "2024-07-01", "amount": 8000, "mode": "Cash" },
          { "date": "2024-09-01", "amount": 7000, "mode": "UPI" },
          { "date": "2024-11-01", "amount": 5000, "mode": "Bank Transfer" }
        ]
      },
      "4C": {
        "rollNo": 4,
        "attendance": {
          "2025-01": { "1": "P", "2": "P", "3": "A", "4": "P", "5": "P" },
          "2025-05": { "1": "P", "2": "P", "3": "P", "4": "P", "5": "P" },
          "2025-06": { "1": "P" }
        },
        "feeStatus": { "total": 23000, "paid": 18000, "due": 5000 },
        "feePayments": [
          { "date": "2025-01-01", "amount": 8000, "mode": "UPI" },
          { "date": "2025-03-10", "amount": 5000, "mode": "Cash" },
          { "date": "2025-05-10", "amount": 5000, "mode": "Bank Transfer" }
        ]
      }
    }
  }
};

final dummyFormerStudents = {
  "fs001": {
    "name": "Aarav Shah",
    "dob": "2019-01-01",
    "contact": "9999111111",
    "parentContact": "9999222222",
    "address": "Jamnagar",
    "appliedYear": 2025
  }
};

final dummyAttendance = {
  "s001": "Present",
  "s002": "Absent"
};
