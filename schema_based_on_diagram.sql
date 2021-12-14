CREATE TABLE patients (
   id INT GENERATED ALWAYS AS IDENTITY,
   name VARCHAR(100),
   date_of_birth DATE,
   PRIMARY KEY(id)
 );
 CREATE TABLE medical_histories (
   id INT GENERATED ALWAYS AS IDENTITY,
   admitted_at TIMESTAMP(0),
   status VARCHAR(30),
   patient_id INT,
   CONSTRAINT patient_fk
   FOREIGN KEY(patient_id) REFERENCES patients(id);  
   PRIMARY KEY(id)
 );
 CREATE TABLE invoices (
   id INT GENERATED ALWAYS AS IDENTITY,
   total_amount DECIMAL,
   generated_at TIMESTAMP(0),
   payed_at TIMESTAMP(0),
   medical_history_id INT,
   CONSTRAINT medical_histories_fk
   FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id);  
   PRIMARY KEY(id)
 );
 CREATE TABLE invoice_item (
   id INT GENERATED ALWAYS AS IDENTITY,
   unit_price DECIMAL,
   quantity INT,
   total_price DECIMAL,
   invoice_id INT,
   treatment_id INT,
   CONSTRAINT invoice_fk
   FOREIGN KEY(invoice_id) REFERENCES invoices(id);  
   CONSTRAINT treatment_fk
   FOREIGN KEY(treatment_id) REFERENCES treatments(id);  
   PRIMARY KEY(id)
 );
 CREATE TABLE treatments (
   id INT GENERATED ALWAYS AS IDENTITY,
   type VARCHAR(100),
   name VARCHAR(100),
   PRIMARY KEY(id)
 );
 CREATE TABLE medical_histories_treatments (  
   medical_history_id INTEGER REFERENCES medical_histories(id),
   treatments_id INTEGER REFERENCES treatments(id)   
 );