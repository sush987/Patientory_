//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//pragma experimental ABIEncoderV2;
contract patientory_doctor{
   // bytes32[10] medical_history;
   //struct to store the name,public key,license number and signature key of the doctor
    struct doctor{
        string name;
        address pubaddress_ofdoctor;
        bytes32 License_Number;
        bytes32 key_to_sign;
    }
   //struct to store the name, pubaddress_of_patient and medical history of patient
    struct patient{
        string name;
        address pubaddress_of_patient;
        //dynamic array of bytes32 to store medical history of a patient
        bytes32[]  medical_history;

    }
    //a bool variable to keep record of whether a doctor is previously registered or not 
   bool registered = false;
   mapping (address => doctor) public doctors; // a mapping of doctors and addresses
   mapping(address => bool) public registered_doctors;// a mapping of addresses and a bool value to check if that particular doctor is already registers
   mapping(address => patient) public patients;


   function register_as_doctor(doctor memory new_signup) public {
       address add = new_signup.pubaddress_ofdoctor;
       //this require iterates through the registered_doctors mapping and checks if that particukar address is previously registered
       require(registered_doctors[add] == false );
       //initailsing the struct to put in the new values of doctor who is registering
       doctor storage d =  doctors[msg.sender];
       registered = true;
       registered_doctors[msg.sender] = registered ;
       d.name = new_signup.name;
       d.pubaddress_ofdoctor = new_signup.pubaddress_ofdoctor;
       d.License_Number = new_signup.License_Number;
       d.key_to_sign = new_signup.key_to_sign;
        
   }


   function add_medicalhistory(address patient_address, bytes32 input, address add_doctor) public {
       patient storage p = patients[patient_address];
       require(registered_doctors[add_doctor]== true,"Not a registered doctor");
       p.medical_history.push(input);
   }
      
    function check_medicalhistory(address patient_address) public view returns(bytes32[] memory){
      patient storage p = patients[patient_address];
       return(p.medical_history);
    }
}

contract patientory_patient is patientory_doctor{
    
     address[] already_registered;
     
     function register_as_patient(patient memory new_signup_patient) public{
        for(uint i =0; i < already_registered.length; i++){
            require(already_registered[i] != msg.sender);
        }
        patient storage p = patients[msg.sender];
        p.name = new_signup_patient.name;
        p.pubaddress_of_patient = new_signup_patient.pubaddress_of_patient;
        p.medical_history = new_signup_patient.medical_history;
        already_registered.push(p.pubaddress_of_patient);
     }
      
     function checkyour_medicalhistory() public view returns(bytes32[] memory){
      patient storage p = patients[msg.sender];
       return(p.medical_history);
    }
}
