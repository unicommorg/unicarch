--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Ubuntu 16.3-1.pgdg23.10+1)
-- Dumped by pg_dump version 16.3

-- Started on 2025-10-03 15:46:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3535 (class 0 OID 25358)
-- Dependencies: 244
-- Data for Name: diagrams_status; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.diagrams_status (id, name, is_deleted, is_first, background_color) VALUES ('2109f2d2-f2a8-43ef-a404-9009c071e5d7', 'Черновик', false, true, '#f2f2f2');
INSERT INTO public.diagrams_status (id, name, is_deleted, is_first, background_color) VALUES ('7c343380-8bd4-493b-a560-a7affb7f181f', 'Удален', true, false, '#fee599');
INSERT INTO public.diagrams_status (id, name, is_deleted, is_first, background_color) VALUES ('eae34d1b-1a28-4dda-8754-e1a56d0e366f', 'В работе', false, false, '#a8d08c');


--
-- TOC entry 3536 (class 0 OID 25388)
-- Dependencies: 245
-- Data for Name: diagrams_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.diagrams_types (id, name, can_have_nested) VALUES ('7c343380-8bd4-493b-a560-a7affb7f181f', 'Диаграмма', false);
INSERT INTO public.diagrams_types (id, name, can_have_nested) VALUES ('70392867-9343-429b-a089-b4443931d19f', 'Папка', true);


--
-- TOC entry 3537 (class 0 OID 25406)
-- Dependencies: 246
-- Data for Name: diagrams_type_status_relation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.diagrams_type_status_relation (type_id, status_id, is_first, is_deleted, id) VALUES ('7c343380-8bd4-493b-a560-a7affb7f181f', 'eae34d1b-1a28-4dda-8754-e1a56d0e366f', false, false, '68fb9c44-45cd-4902-8d96-5346f04c3fc6');
INSERT INTO public.diagrams_type_status_relation (type_id, status_id, is_first, is_deleted, id) VALUES ('7c343380-8bd4-493b-a560-a7affb7f181f', '2109f2d2-f2a8-43ef-a404-9009c071e5d7', true, false, '72113410-6713-4389-957d-f1ecfaddd71b');
INSERT INTO public.diagrams_type_status_relation (type_id, status_id, is_first, is_deleted, id) VALUES ('7c343380-8bd4-493b-a560-a7affb7f181f', '7c343380-8bd4-493b-a560-a7affb7f181f', false, true, 'ce0ad0ba-d9e7-4d6d-b025-8efff4db40cb');
INSERT INTO public.diagrams_type_status_relation (type_id, status_id, is_first, is_deleted, id) VALUES ('70392867-9343-429b-a089-b4443931d19f', 'eae34d1b-1a28-4dda-8754-e1a56d0e366f', true, false, 'd48eef68-f14c-4cd2-ab78-85c9eae2063c');
INSERT INTO public.diagrams_type_status_relation (type_id, status_id, is_first, is_deleted, id) VALUES ('70392867-9343-429b-a089-b4443931d19f', '7c343380-8bd4-493b-a560-a7affb7f181f', false, true, '9ebc1c94-ad92-4415-bc6c-4ff2e533b207');


--
-- TOC entry 3538 (class 0 OID 25472)
-- Dependencies: 249
-- Data for Name: integrations_protocols; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('6db3caea-e7c3-4de9-9efd-0a279df4ef7c', 'SAP/ALE', 'ALE/IDOC', NULL, '3200-3299;3300-3399;3600-3699', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7d88c8ed-4e5a-405f-a01c-9be72972cc0b', 'ASAI', 'Adjunct/Switch Application Interface', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('9fff860e-a015-4f21-b2c5-045e9cb0d635', 'TCP', 'binary', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('5e6656eb-b7c7-4af1-b3d4-29f3f14a45c5', 'EQ/CHI', 'CHI (Cashier Host Interface)', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1327ab34-dc1e-427e-9699-cc7264c197ab', 'DirectCall', '<p>Взаимодействие между API внутри Equation</p>', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('60d19b9f-877e-43f0-a7d9-fd5b87462bb4', 'DRDA', 'Протокол для загрузки из EQ в БД Informix', '446', '446', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('539db66a-280e-4daf-814e-f23571209ca5', 'HTTP/GraphQL', 'HTTPS/GraphQL', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('8ef4a177-c412-4e6c-beb3-6cfe50e87d7f', 'HTTP/gRPC', 'gRPC/HTTP/2', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('b8b46715-8bbd-4d50-9708-1af7fb50cab5', 'GSM', 'GSM', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('21b99815-8830-4c05-8077-87685cea9f8a', 'H.323', 'Video conferencing protocol', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1505a413-855d-4ed7-91c1-be0d3b6bf27e', 'HTTP/REST', 'HTTP/REST', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('f82d569b-73e4-4101-95cb-d2773adf96c9', 'HTTP/SOAP', 'HTTP/SOAP', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('d2d0f853-0284-4586-b08a-b8b1a6877190', 'HTTP', 'HTTPS', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('11d61ba4-8844-4399-86e1-c2227cfd762e', 'IBM/MQ', 'IBM MQ', NULL, '1400-1500', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('a6018f29-8eca-4d4a-920d-c621d8a77cdd', 'ICAP', 'ICAP', NULL, '1344', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('8c7b42bd-742b-46fa-ad0c-148de89595b2', 'IMAP', 'IMAP', '993', '143', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7c6f9ef3-0cf2-4c54-859f-0e02473cbc3f', 'DCE/RPC', 'Интеграция НСПК и Янтарь', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('4652d463-725c-49f8-899e-2dad55280689', 'JDBC', 'Способ взаимодействия Java-приложений с реляционными СУБД. Применяется для отображения прямого доступа к данным реляционной СУБД с применением JDBC типа 2, 3 или 4. Формат данных и номер TCP-порта не определен. Не применяется для расширений JDBC.', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('dbebc587-49d1-459f-a47f-dcc34ca3095a', 'HTTP/JSON-RPC', 'JSON-RPC', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('015b7750-0594-45e1-82c9-f4a3685dca6c', 'LDAP', 'LDAP', '636', '389', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('fb3a6398-6b4f-47f0-b61a-80982bad761f', 'MongoDB', 'Mongo Wired Protocol', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('cb14b561-cbee-4ae8-8261-8008f89217cc', 'NDC', 'NCR Dirrect Comnect ATM protocol', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('d6f53898-7024-4be5-a040-77526a90135e', 'OCI', 'OCI/Oracle native', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1f61803f-d651-4cd4-aeb8-f1b8a4790f10', 'ODBC', 'Спецификация API базы данных. Применяется для отображения прямого доступа к данным реляционной СУБД с применением ODBC (в том числе с использованием JDBC 1-го типа) без указания конкретного типа СУБД. Формат данных и номер TCP-порта не определен', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('3cab76bc-db67-498e-898a-52817da64ea3', 'SAP/RFC', 'RFC', NULL, '3200-3299;3300-3399;3600-3699', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('4a805746-c5ae-4862-bfba-4243d891ba43', 'RTSP', 'real time streaming protocol', NULL, '554', true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('87b6ee49-45de-4707-bae4-9683110e8378', 'HTTP/S3', 'HTTP/S3', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('21bf3082-ded9-4148-ab41-d80397ffc244', 'SIP', 'SIP', NULL, '5060', true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('afcf0b41-6e1f-4950-a69f-1b6059a9a6cc', 'SMB', 'SMB', NULL, '445', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('81c06305-5066-4f9a-a5a5-fa431d1cbce5', 'SMTP', 'SMTP', NULL, '25', true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('37819fe0-e4ea-44fb-853a-7d7dabd70541', 'RTP', 'Secure Real-time Transport Protocol', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('0ffa46b9-1b9c-40eb-8503-ae1ff98b6403', 'Kafka', 'TCP/Kafka+TLS', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('81176ac6-8b80-479f-8e03-f84930cc9f48', 'MS/TDS', 'Tabular Data Stream', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1f9e6008-7af7-4a80-b802-342a6ff4dbea', 'HTTP/Thrift', 'Thrift/HTTPS', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('13f7987e-40ba-4842-a036-a3efaa90e5c1', 'TSAPI', 'TSAPI', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('5e01d5a6-d21c-441e-8132-1223a7242787', 'SAP/XDN', 'DataBase driver for SAP', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('d3665960-a2e1-4535-bb96-44d60bebf118', 'FTP', 'FTP', '990', '21', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('2e98e562-8803-4e39-a084-f2fc1d3effb7', 'SFTP', 'SSH File Transfer Protocol. Отличен от FTPS (FTP + SSL)', '22', '22', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('a416bd78-5f25-411e-999b-bc9210a5c389', 'ISO 8583', 'стандарт ISO на протокол для карточных операций', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('8704f27b-df77-4239-b7fc-70614bb0f838', 'Kerberos', 'Kerberos - стандартный протокол аутентификации для Active Directory', NULL, '88', true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('5784a1bc-a18c-4bb1-b2b5-6faebea021d0', 'UDP', 'User Datagram Protocol on top of IP', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('bde5403f-4438-46ab-98ad-154994a038ee', 'NFS', 'Network File System', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7050d3f7-9d8e-4839-9843-e2bee3af5086', 'MRCP', 'Протокол управления медиа-ресурсами (MRCP) — это протокол передачи данных, используемый серверами для предоставления различных услуг (таких как распознавание речи и синтез речи) для своих клиентов. MRCP опирается на другие протоколы, в частности, потоковый протокол реального времени (протокол RTSP) или протокол установления сеанса связи (протокол SIP) для установления и управления сеансом аудиопотоков между клиентом и сервером. Avaya MPP ASR/TTS', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('b56cd31b-cb02-4bdc-b0bf-5c3664cfb0ed', 'JTAPI', 'API Java Telephone API - это набор интерфейсов программ, связанных с телефонными приложениями для языков Java, которые определяют набор кроссплатформенных, перекрестных телефонных приложений (VoiceBot JAICP)', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('15bbc80f-4465-4b9d-af12-2fdb7afa1c7f', 'TDS', 'Microsoft Tabular Data Stream ', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1d9ce25e-d1a9-4d61-ab1f-18037e1a2454', 'FIX', 'Financial Information eXchange protocol&nbsp', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1761e63c-c994-4dd3-bd07-6dffb60ab75b', 'NTP', 'Network Time Protocol', NULL, '123', true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('e2186e9b-3fcd-4f74-9878-45c92e7ec673', 'SSH', 'Secure Shell', '22', '22', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7004e92b-9664-48b6-b1bf-15939cd67c3f', 'RDP', 'Remote Desktop Protocol', NULL, '3389', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('c3dadbb7-8369-404f-b659-68be268dcc15', 'WebSocket', 'WebSocket', '443', '80', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('e90b94fb-e43a-48eb-b865-32e51e1bb89e', 'RESP', 'Redis serialization protocol (RESP)', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('321b08cb-d1fd-4646-80bc-98ea6de06f57', 'Citrix/ICA', 'Citrix ICA/HDX', '1494;2598', '1494;2598', true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('728da7ac-4537-4309-a4bd-cab1a30f4588', 'Notes RPC', 'Проткол взаимодействие БД Notes', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('4d4e34dd-0a2a-46c4-9f27-e3df07ec2aa4', 'CDC', 'Change Data Capture. Технология стриминга изменений БД без дополнительных запросов со стороны получателя. Примеры: Oracle GoldenGate, Debezium, VisionSolutions DoubleTake, Датафлот Репликация. Формат данных и номер TCP-порта не определен.', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('00f5841d-6d5e-4ef6-b093-d6a83fb31d27', 'ADO.NET', 'Набор классов, предоставляющих службы доступа к данным программистам, которые используют платформу .NET Framework.', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7a2d3f16-4937-4366-b00b-2f0bab597821', 'SNMP', 'SNMP (англ. Simple Network Management Protocol — простой протокол сетевого управления) — стандартный интернет-протокол для управления устройствами в IP-сетях.', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('66ae05fb-53ea-4f43-92c6-69d700d5826e', 'Diameter', 'Протокол обмена в сетях 3gpp(мобильная телефония). Аутентификация/авторизация.', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('16b193da-0267-4356-baa9-3f8a5082f65f', 'RADIUS', 'Remote Authentication Dial In User Service, протокол удалённой аутентификации дозванивающихся пользователей. (мобильная телефония)', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('6f1b999a-7c81-4710-a493-43adb3d8cd90', 'CAMEL/M3UA', 'протокол обмена, поддерживающий сигнализацию SigTran и адаптацию пользовательского уровня MTP-3 из телефонного стека протоколов ОКС-7 (SS7)', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('b951d0c4-8e32-4478-bd08-262ea2c71101', 'GTP', 'используется в базовой сети GPRS для передачи сигналов между узлами поддержки GPRS шлюза (GGSN) и обслуживающими узлами', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('1934c5fa-b621-4613-8f95-47155b7dfb4d', 'SMPP', 'протокол (Short Message Peer-to-Peer Protocol) — это одноранговый протокол коротких сообщений - это для sms, ussd', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('12036673-8d90-4413-b158-73cdc34e381e', 'XMPP', 'Расширяемый протокол обмена сообщениями и информацией о присутствии (Jabber)&nbsp; для  коммуникационной сети мессенджеров', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('6f18ddc7-40d5-42f1-959d-fbbbcb10728c', 'BFCP', 'Binary Floor Control Protocol (BFCP) for video screen sharing capabilities in&nbsp;Jabber-app', '5070-6070', NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('d3ef7677-f33c-4671-89a3-19118a26cc74', 'sRTP', 'Безопасная версия RTP (сквозное шифрование, аутентификация, защита от подделки пакетов). Используется<br>в WebRTC, Zoom, Microsoft Teams, WhatsApp, VoIP', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('9edb6087-f843-4c51-a273-0782b6bc3908', 'WebRTC', 'WebRTC (Web Real-Time Communication) - протокол обмена&nbsp; аудио, видео и данными в режиме реального времени без установки дополнительных плагинов&nbsp; для браузеров и мобильных приложения', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('b0f3e6a0-b766-44e1-b32c-1acb6000739a', 'RTMP', 'Real Time Messaging Protocol — проприетарный протокол потоковой передачи данных, в основном используемый для передачи потокового видео и аудиопотоков с веб-камер через интернет', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('18b7725c-3a66-4df3-b539-85b928dc16e5', 'RTMPS', 'защищенный протокол передачи, в отличие от классического RTMP использует SSL/TLS.', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7ef418e3-c333-4ee3-ad66-25460ce558e9', 'IDC', 'Inter-domain Controller&nbsp;(IDC) Protocol', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('6f4e89ff-ddd9-4e20-ad12-6ee7736fcd21', 'EQ Async Exchange', 'Протокол межпроцессных интеграций в EQ, где важно показать асинхронность', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('2c2c9ca6-6213-42ab-8b31-273fc63248b0', 'syslog', 'протокол и стандарт отправки и регистрации сообщений о происходящих в системе событиях', NULL, NULL, true, 'Опционально');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('7bb6408a-d1e9-47c8-a41e-3fe9a658e3e6', 'Iframe/WMF/redirect', 'Протокол для условного отображения взаимодействия объектов через клиентскую часть (браузер - встройка, редирект). Не требует получения сетевого доступа между объектами.', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('af1a6a55-3ff4-4338-8727-747d66e7341a', 'swagger test', '', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('e83186bb-1d29-442e-b18e-3755ac3707fa', 'test from ui', '', NULL, NULL, true, 'Нет');
INSERT INTO public.integrations_protocols (id, name, description, port_with_sec, port_without_sec, status_in_use, transport_layer_sec) VALUES ('560cd1f8-2214-46ed-b5da-fb49350d0a5c', 'MQ', '', NULL, NULL, true, 'Нет');


--
-- TOC entry 3527 (class 0 OID 16503)
-- Dependencies: 220
-- Data for Name: object_status; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.object_status (id, name, description, color, isdeleted, isdisabled, for_diagram) VALUES ('bfce5c2e-0f78-4ff8-afe0-30110c0062b2', 'Удален', '', '#fee599', true, false, false);
INSERT INTO public.object_status (id, name, description, color, isdeleted, isdisabled, for_diagram) VALUES ('5a27049e-7612-449b-be19-ee29094ecb7d', 'Выведен', '', '#b3c6e7', false, true, false);
INSERT INTO public.object_status (id, name, description, color, isdeleted, isdisabled, for_diagram) VALUES ('a299cf42-f752-4c1e-ab88-b6743b470c1d', 'В работе', '', '#a8d08c', false, false, true);
INSERT INTO public.object_status (id, name, description, color, isdeleted, isdisabled, for_diagram) VALUES ('c39adad1-5ad5-4b2a-b043-735e265d4b26', 'Черновик', '', '#f2f2f2', false, false, false);
INSERT INTO public.object_status (id, name, description, color, isdeleted, isdisabled, for_diagram) VALUES ('ee6441b5-1fc4-4700-918d-a4c697b2f7e5', 'К выводу', '', '#f7caac', false, false, true);


--
-- TOC entry 3528 (class 0 OID 16511)
-- Dependencies: 222
-- Data for Name: object_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.object_type (id, type_name, short_name, back_color, start_date, end_date) VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', 'Компонента', 'C', '#ccc02e', NULL, NULL);
INSERT INTO public.object_type (id, type_name, short_name, back_color, start_date, end_date) VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', 'Пользователь', 'U', '#2eb8cc', NULL, NULL);
INSERT INTO public.object_type (id, type_name, short_name, back_color, start_date, end_date) VALUES ('3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', 'Метод', 'Mtd', '#FFFF33', NULL, NULL);
INSERT INTO public.object_type (id, type_name, short_name, back_color, start_date, end_date) VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 'Сервис/Микросервис', 'Srv', '#cc912e', NULL, NULL);
INSERT INTO public.object_type (id, type_name, short_name, back_color, start_date, end_date) VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', 'Модуль', 'M', '#77D9D3', NULL, NULL);
INSERT INTO public.object_type (id, type_name, short_name, back_color, start_date, end_date) VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', 'Система', 'S', '#2ecc71', NULL, NULL);


--
-- TOC entry 3534 (class 0 OID 25307)
-- Dependencies: 242
-- Data for Name: property_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.property_types (id, name, type, ismulti) VALUES ('4daa2656-0780-492e-9086-42758e3ead1e', 'Справочник', 'select', true);
INSERT INTO public.property_types (id, name, type, ismulti) VALUES ('9447394b-8fdb-40e4-8b28-9402a2f7db25', 'Текст', 'text', false);
INSERT INTO public.property_types (id, name, type, ismulti) VALUES ('8634c499-d850-401f-bd5d-7f13bee54489', 'Дата', 'date', false);


--
-- TOC entry 3530 (class 0 OID 25154)
-- Dependencies: 232
-- Data for Name: status_relation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES (NULL, 'a299cf42-f752-4c1e-ab88-b6743b470c1d', 1);
INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES ('a299cf42-f752-4c1e-ab88-b6743b470c1d', 'c39adad1-5ad5-4b2a-b043-735e265d4b26', 4);
INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES ('a299cf42-f752-4c1e-ab88-b6743b470c1d', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5', 6);
INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES ('ee6441b5-1fc4-4700-918d-a4c697b2f7e5', 'a299cf42-f752-4c1e-ab88-b6743b470c1d', 7);
INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES ('ee6441b5-1fc4-4700-918d-a4c697b2f7e5', '5a27049e-7612-449b-be19-ee29094ecb7d', 9);
INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES ('5a27049e-7612-449b-be19-ee29094ecb7d', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5', 10);
INSERT INTO public.status_relation (current_status, next_status, id) OVERRIDING SYSTEM VALUE VALUES ('c39adad1-5ad5-4b2a-b043-735e265d4b26', 'a299cf42-f752-4c1e-ab88-b6743b470c1d', 11);


--
-- TOC entry 3529 (class 0 OID 16557)
-- Dependencies: 227
-- Data for Name: type_relation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES (NULL, '81f74539-5b0f-4e02-b091-c05d110bfacb', 1);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', '27a052da-4b92-45b1-84a8-2bcbf27c34e1', 2);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', '081c831c-c6af-41aa-939e-13ba7289d669', 3);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', '081c831c-c6af-41aa-939e-13ba7289d669', 4);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES (NULL, 'd70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 5);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES (NULL, '64f336a3-ae27-4113-9b8f-785360ec0802', 6);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', '081c831c-c6af-41aa-939e-13ba7289d669', 7);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', 'd70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 8);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 'd70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 9);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', '3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', 10);
INSERT INTO public.type_relation (parent_type_id, child_type_id, id) OVERRIDING SYSTEM VALUE VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', '64f336a3-ae27-4113-9b8f-785360ec0802', 11);


--
-- TOC entry 3531 (class 0 OID 25167)
-- Dependencies: 233
-- Data for Name: type_status_relation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.type_status_relation (type, status) VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', 'c39adad1-5ad5-4b2a-b043-735e265d4b26');
INSERT INTO public.type_status_relation (type, status) VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5');
INSERT INTO public.type_status_relation (type, status) VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', 'bfce5c2e-0f78-4ff8-afe0-30110c0062b2');
INSERT INTO public.type_status_relation (type, status) VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', 'a299cf42-f752-4c1e-ab88-b6743b470c1d');
INSERT INTO public.type_status_relation (type, status) VALUES ('81f74539-5b0f-4e02-b091-c05d110bfacb', '5a27049e-7612-449b-be19-ee29094ecb7d');
INSERT INTO public.type_status_relation (type, status) VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', 'c39adad1-5ad5-4b2a-b043-735e265d4b26');
INSERT INTO public.type_status_relation (type, status) VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5');
INSERT INTO public.type_status_relation (type, status) VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', 'bfce5c2e-0f78-4ff8-afe0-30110c0062b2');
INSERT INTO public.type_status_relation (type, status) VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', 'a299cf42-f752-4c1e-ab88-b6743b470c1d');
INSERT INTO public.type_status_relation (type, status) VALUES ('27a052da-4b92-45b1-84a8-2bcbf27c34e1', '5a27049e-7612-449b-be19-ee29094ecb7d');
INSERT INTO public.type_status_relation (type, status) VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', 'c39adad1-5ad5-4b2a-b043-735e265d4b26');
INSERT INTO public.type_status_relation (type, status) VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5');
INSERT INTO public.type_status_relation (type, status) VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', 'bfce5c2e-0f78-4ff8-afe0-30110c0062b2');
INSERT INTO public.type_status_relation (type, status) VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', 'a299cf42-f752-4c1e-ab88-b6743b470c1d');
INSERT INTO public.type_status_relation (type, status) VALUES ('081c831c-c6af-41aa-939e-13ba7289d669', '5a27049e-7612-449b-be19-ee29094ecb7d');
INSERT INTO public.type_status_relation (type, status) VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', 'a299cf42-f752-4c1e-ab88-b6743b470c1d');
INSERT INTO public.type_status_relation (type, status) VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 'a299cf42-f752-4c1e-ab88-b6743b470c1d');
INSERT INTO public.type_status_relation (type, status) VALUES ('3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', 'a299cf42-f752-4c1e-ab88-b6743b470c1d');
INSERT INTO public.type_status_relation (type, status) VALUES ('3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', 'c39adad1-5ad5-4b2a-b043-735e265d4b26');
INSERT INTO public.type_status_relation (type, status) VALUES ('3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5');
INSERT INTO public.type_status_relation (type, status) VALUES ('3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', 'bfce5c2e-0f78-4ff8-afe0-30110c0062b2');
INSERT INTO public.type_status_relation (type, status) VALUES ('3fe62f2e-e7f4-489c-a5fa-f1bdef091ca1', '5a27049e-7612-449b-be19-ee29094ecb7d');
INSERT INTO public.type_status_relation (type, status) VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 'c39adad1-5ad5-4b2a-b043-735e265d4b26');
INSERT INTO public.type_status_relation (type, status) VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 'bfce5c2e-0f78-4ff8-afe0-30110c0062b2');
INSERT INTO public.type_status_relation (type, status) VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5');
INSERT INTO public.type_status_relation (type, status) VALUES ('d70c8f44-9a5b-4f36-a9dd-330e61cf3c93', '5a27049e-7612-449b-be19-ee29094ecb7d');
INSERT INTO public.type_status_relation (type, status) VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', 'bfce5c2e-0f78-4ff8-afe0-30110c0062b2');
INSERT INTO public.type_status_relation (type, status) VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', '5a27049e-7612-449b-be19-ee29094ecb7d');
INSERT INTO public.type_status_relation (type, status) VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', 'c39adad1-5ad5-4b2a-b043-735e265d4b26');
INSERT INTO public.type_status_relation (type, status) VALUES ('64f336a3-ae27-4113-9b8f-785360ec0802', 'ee6441b5-1fc4-4700-918d-a4c697b2f7e5');


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 234
-- Name: status_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.status_relation_id_seq', 12, true);


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 235
-- Name: type_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.type_relation_id_seq', 11, true);


-- Completed on 2025-10-03 15:46:36

--
-- PostgreSQL database dump complete
--

