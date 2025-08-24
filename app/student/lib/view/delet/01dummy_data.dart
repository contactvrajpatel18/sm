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
