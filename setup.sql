CREATE DATABASE IF NOT EXISTS net_learn CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE net_learn;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  fullname VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('student','admin') NOT NULL DEFAULT 'student',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS lessons (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(190) NOT NULL,
  slug VARCHAR(190) NOT NULL UNIQUE,
  category VARCHAR(80) NOT NULL DEFAULT 'Foundations',
  summary TEXT NOT NULL,
  body LONGTEXT NOT NULL,
  minutes SMALLINT UNSIGNED NOT NULL DEFAULT 8,
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS activities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(190) NOT NULL,
  category VARCHAR(80) NOT NULL DEFAULT 'Network lab',
  summary TEXT NOT NULL,
  steps LONGTEXT NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS resources (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(190) NOT NULL,
  kind VARCHAR(50) NOT NULL DEFAULT 'Guide',
  description TEXT NOT NULL,
  url VARCHAR(500) NULL,
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS quizzes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  lesson_id BIGINT UNSIGNED NULL,
  title VARCHAR(190) NOT NULL,
  description TEXT NOT NULL,
  CONSTRAINT quizzes_lesson_fk FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS questions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  quiz_id BIGINT UNSIGNED NOT NULL,
  prompt TEXT NOT NULL,
  option_a VARCHAR(255) NOT NULL,
  option_b VARCHAR(255) NOT NULL,
  option_c VARCHAR(255) NOT NULL,
  option_d VARCHAR(255) NOT NULL,
  answer CHAR(1) NOT NULL,
  explanation TEXT NOT NULL,
  sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  CONSTRAINT questions_quiz_fk FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS lesson_progress (
  user_id BIGINT UNSIGNED NOT NULL,
  lesson_id BIGINT UNSIGNED NOT NULL,
  completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, lesson_id),
  CONSTRAINT lp_user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT lp_lesson_fk FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS activity_progress (
  user_id BIGINT UNSIGNED NOT NULL,
  activity_id BIGINT UNSIGNED NOT NULL,
  completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, activity_id),
  CONSTRAINT ap_user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT ap_activity_fk FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS quiz_attempts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  quiz_id BIGINT UNSIGNED NOT NULL,
  score SMALLINT UNSIGNED NOT NULL,
  total SMALLINT UNSIGNED NOT NULL,
  attempted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY attempts_by_user (user_id, attempted_at),
  CONSTRAINT qa_user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT qa_quiz_fk FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO lessons (title,slug,category,summary,body,minutes,sort_order)
SELECT 'How networks communicate','network-basics','Foundations','Meet the devices and rules that let computers exchange information.','A computer network connects devices so they can share information and services. End devices include computers, phones, and servers. Switches connect devices inside a local network; routers move traffic between different networks.\n\nEvery device uses agreed rules called protocols. When you open a website, your device prepares data, addresses it, and sends it through one or more networks to a server. The server replies using the same layered process.\n\nTry this: name one end device, one intermediary device, and one service you use each day.',8,1
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug='network-basics');
INSERT INTO lessons (title,slug,category,summary,body,minutes,sort_order)
SELECT 'The OSI model','osi-model','Foundations','Use seven layers to describe how data moves from an app to a network cable.','The OSI model is a learning framework for describing communication. From top to bottom: 7 Application, 6 Presentation, 5 Session, 4 Transport, 3 Network, 2 Data Link, and 1 Physical.\n\nAs data travels down the layers, each layer adds information it needs. At the receiver, the process is reversed. The model helps isolate problems: a disconnected cable is a Physical layer issue, while an incorrect IP route is a Network layer issue.\n\nMemory cue from layer 1 upward: Please Do Not Throw Sausage Pizza Away.',10,2
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug='osi-model');
INSERT INTO lessons (title,slug,category,summary,body,minutes,sort_order)
SELECT 'IPv4 addressing and subnet masks','ipv4-subnets','Addressing','Read an IPv4 address and identify which part names the network.','An IPv4 address contains 32 bits, usually written as four decimal octets, such as 192.168.10.25. A subnet mask separates the network portion from the host portion. CIDR notation writes the number of network bits after a slash: 192.168.10.25/24.\n\nA /24 mask is 255.255.255.0. In the network 192.168.10.0/24, usable host addresses are commonly 192.168.10.1 through 192.168.10.254; .0 identifies the network and .255 is its broadcast address.\n\nPractice: for 10.1.4.23/24, identify the network address and the final usable host address.',12,3
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug='ipv4-subnets');
INSERT INTO lessons (title,slug,category,summary,body,minutes,sort_order)
SELECT 'Switches, VLANs, and trunks','vlans','Switching','Separate networks logically while sharing the same physical switch.','A VLAN (Virtual Local Area Network) creates a logical broadcast domain on a switch. Devices in different VLANs are separated even when they use the same switch. A switch port assigned to one VLAN is usually an access port.\n\nA trunk link carries traffic for multiple VLANs between network devices. IEEE 802.1Q tagging marks each frame with its VLAN identity. Devices in different VLANs need a router or Layer 3 switch to communicate.\n\nDesign exercise: place staff computers in VLAN 10 and student computers in VLAN 20. Which links between switches need to carry both VLANs?',10,4
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug='vlans');
INSERT INTO lessons (title,slug,category,summary,body,minutes,sort_order)
SELECT 'Routing and packet delivery','routing','Routing','Follow a packet across networks and understand the router’s next-hop choice.','A router forwards packets between IP networks. It checks the destination IP address and compares it with entries in its routing table. The most specific matching route is selected. If no specific route matches, a default route may be used.\n\nStatic routes are entered by an administrator. Dynamic routing protocols such as RIP and OSPF let routers share route information. RIP uses hop count and is useful for learning basic routing ideas; OSPF calculates paths using link costs and is widely used in larger internal networks.\n\nRemember: switches forward frames within a local network; routers forward packets between networks.',12,5
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug='routing');

INSERT INTO activities (title,category,summary,steps,sort_order)
SELECT 'Build a small LAN','LAN setup','Connect two computers through a switch and test local communication.','1. Add two computer nodes and a switch to the workspace.\n2. Connect each computer to the switch.\n3. Give the computers addresses 192.168.1.10/24 and 192.168.1.11/24.\n4. Send a test packet from PC A to PC B.\n5. Explain why both devices can communicate on the same subnet.',1 WHERE NOT EXISTS (SELECT 1 FROM activities WHERE title='Build a small LAN');
INSERT INTO activities (title,category,summary,steps,sort_order)
SELECT 'Plan a subnet','Subnetting','Practice choosing a subnet for a small computer lab.','1. Your lab needs 20 device addresses.\n2. Choose a prefix that provides enough usable IPv4 addresses.\n3. For 192.168.20.0/27, identify the network, usable range, and broadcast address.\n4. Check your work: a /27 contains 32 addresses, usually 30 usable host addresses.',2 WHERE NOT EXISTS (SELECT 1 FROM activities WHERE title='Plan a subnet');
INSERT INTO activities (title,category,summary,steps,sort_order)
SELECT 'Separate staff and student VLANs','VLAN configuration','Sketch a two-VLAN layout and decide where routing is needed.','1. Create VLAN 10 for staff and VLAN 20 for students.\n2. Connect one staff PC and one student PC to access ports.\n3. Connect two switches with a trunk that carries VLANs 10 and 20.\n4. Explain why a router or Layer 3 switch is needed for traffic between the VLANs.',3 WHERE NOT EXISTS (SELECT 1 FROM activities WHERE title='Separate staff and student VLANs');
INSERT INTO activities (title,category,summary,steps,sort_order)
SELECT 'Choose a route','Routing','Follow a destination through a simple routing table.','1. Imagine a router with routes for 10.0.0.0/8, 10.1.0.0/16, and a default route.\n2. A packet arrives for 10.1.2.8.\n3. Select the most specific matching route.\n4. Explain why the default route is not selected.',4 WHERE NOT EXISTS (SELECT 1 FROM activities WHERE title='Choose a route');

INSERT INTO resources (title,kind,description,url,sort_order)
SELECT 'Cisco Packet Tracer','Simulation tool','Use Packet Tracer to build and test virtual network topologies. Download it from Cisco Networking Academy.','https://www.netacad.com/cisco-packet-tracer',1 WHERE NOT EXISTS (SELECT 1 FROM resources WHERE title='Cisco Packet Tracer');
INSERT INTO resources (title,kind,description,url,sort_order)
SELECT 'Subnetting practice','Practice guide','A guided set of subnetting exercises. Use the activities in this platform and verify your address ranges with a calculator.','',2 WHERE NOT EXISTS (SELECT 1 FROM resources WHERE title='Subnetting practice');
INSERT INTO resources (title,kind,description,url,sort_order)
SELECT 'Wireshark learning','Packet analysis','Explore packet captures to see how protocols appear in real network traffic.','https://www.wireshark.org/docs/',3 WHERE NOT EXISTS (SELECT 1 FROM resources WHERE title='Wireshark learning');
INSERT INTO resources (title,kind,description,url,sort_order)
SELECT 'Cisco Networking Academy','Video and lessons','Free introductory networking courses and learning materials may be available through Cisco Networking Academy.','https://www.netacad.com/',4 WHERE NOT EXISTS (SELECT 1 FROM resources WHERE title='Cisco Networking Academy');

INSERT INTO quizzes (title,description,lesson_id) SELECT 'Network foundations check','Check your understanding of devices and basic communication.',(SELECT id FROM lessons WHERE slug='network-basics') WHERE NOT EXISTS (SELECT 1 FROM quizzes WHERE title='Network foundations check');
INSERT INTO quizzes (title,description,lesson_id) SELECT 'Addressing and VLANs check','Practice subnet and switching concepts.',(SELECT id FROM lessons WHERE slug='ipv4-subnets') WHERE NOT EXISTS (SELECT 1 FROM quizzes WHERE title='Addressing and VLANs check');
INSERT INTO quizzes (title,description,lesson_id) SELECT 'Routing check','Review how routers select paths.',(SELECT id FROM lessons WHERE slug='routing') WHERE NOT EXISTS (SELECT 1 FROM quizzes WHERE title='Routing check');

INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'Which device forwards traffic between different IP networks?','Hub','Router','Repeater','Wireless access point','b','Routers use IP addresses and routing tables to forward packets between networks.',1 FROM quizzes q WHERE q.title='Network foundations check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'Which OSI layer is associated with IP addressing?','Physical','Data Link','Network','Presentation','c','The Network layer (Layer 3) handles logical addressing and routing.',2 FROM quizzes q WHERE q.title='Network foundations check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'What is a protocol?','A physical cable type','A shared set of communication rules','A type of switch','A web browser','b','Protocols define rules that devices follow to communicate.',3 FROM quizzes q WHERE q.title='Network foundations check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'What does a switch primarily connect?','Devices within a local network','Two unrelated internet providers','A website to its domain name','Only wireless devices','a','Switches forward frames among devices in a local network.',4 FROM quizzes q WHERE q.title='Network foundations check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);

INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'How many usable host addresses are commonly available in a /24 IPv4 subnet?','24','128','254','256','c','A /24 has 256 total addresses; network and broadcast addresses are typically reserved, leaving 254 usable host addresses.',1 FROM quizzes q WHERE q.title='Addressing and VLANs check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'What is the network address for 192.168.10.25/24?','192.168.10.0','192.168.10.25','192.168.10.255','192.168.0.0','a','A /24 uses the first three octets as the network part, so the network address ends in .0.',2 FROM quizzes q WHERE q.title='Addressing and VLANs check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'What does a VLAN create?','A faster physical cable','A logical broadcast domain','A public IP address','A routing protocol','b','A VLAN logically separates devices into different broadcast domains.',3 FROM quizzes q WHERE q.title='Addressing and VLANs check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'Which link type can carry multiple VLANs?','Access link','Trunk link','Console link','Loopback link','b','A trunk link carries tagged traffic for multiple VLANs.',4 FROM quizzes q WHERE q.title='Addressing and VLANs check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);

INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'What information does a router use to forward an IP packet?','Destination IP address','Screen size','Source MAC only','Application color','a','The router checks the destination IP against its routing table.',1 FROM quizzes q WHERE q.title='Routing check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'When several routes match, which one is generally chosen?','The oldest route','The most specific matching route','The route with the shortest name','The default route every time','b','Routers generally choose the longest prefix, which is the most specific matching route.',2 FROM quizzes q WHERE q.title='Routing check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'Which is an example of a dynamic routing protocol?','HTTP','OSPF','HTML','USB','b','OSPF is a dynamic routing protocol used to exchange route information.',3 FROM quizzes q WHERE q.title='Routing check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);
INSERT INTO questions (quiz_id,prompt,option_a,option_b,option_c,option_d,answer,explanation,sort_order)
SELECT q.id,'What can a default route provide?','A path when no more specific route matches','A way to rename a VLAN','A replacement for IP addresses','A list of passwords','a','A default route is used when no more specific route matches the destination.',4 FROM quizzes q WHERE q.title='Routing check' AND NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id=q.id);




