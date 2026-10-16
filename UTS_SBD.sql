CREATE TABLE Hotel(
hotelNo VARCHAR(50) PRIMARY KEY,
hotelName VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL
);		

CREATE TABLE Guest (
  guestNo      VARCHAR(10) PRIMARY KEY,
  guestName    VARCHAR(50) NOT NULL,
  guestAddress VARCHAR(100)
);

CREATE TABLE Room (
  roomNo  INT,
  hotelNo VARCHAR(10),
  type    VARCHAR(10) NOT NULL,
  price   DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (roomNo, hotelNo),
  FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo),
  CONSTRAINT cek_tipe_room   CHECK (type IN ('Single', 'Double', 'Family')),        
  CONSTRAINT cek_harga_room  CHECK (price BETWEEN 10 AND 100),                       
  CONSTRAINT cek_nomor_ruangan  CHECK (roomNo BETWEEN 1 AND 100)                        
);

CREATE TABLE Booking (
  hotelNo  VARCHAR(10),
  guestNo  VARCHAR(10),
  dateFrom DATE,
  dateTo   DATE,
  roomNo   INT,
  PRIMARY KEY (hotelNo, guestNo, dateFrom),
  FOREIGN KEY (guestNo)            REFERENCES Guest(guestNo),
  FOREIGN KEY (roomNo, hotelNo)    REFERENCES Room(roomNo, hotelNo),
  CONSTRAINT dari_tanggal_berapa   CHECK (dateFrom > CURRENT_DATE),
  CONSTRAINT sampai_tanggal_berapa CHECK (dateTo > CURRENT_DATE)                        
);


CREATE ASSERTION no_double_booked_room CHECK (NOT EXISTS (
  SELECT * FROM Booking b1 JOIN Booking b2
    ON b1.hotelNo = b2.hotelNo AND b1.roomNo = b2.roomNo
   AND (b1.guestNo <> b2.guestNo OR b1.dateFrom <> b2.dateFrom)
   AND b1.dateFrom <= b2.dateTo AND b2.dateFrom <= b1.dateTo
));


CREATE ASSERTION no_overlap_guest CHECK (NOT EXISTS (
  SELECT * FROM Booking b1 JOIN Booking b2
    ON b1.guestNo = b2.guestNo
   AND (b1.hotelNo <> b2.hotelNo OR b1.roomNo <> b2.roomNo OR b1.dateFrom <> b2.dateFrom)
   AND b1.dateFrom <= b2.dateTo AND b2.dateFrom <= b1.dateTo
));