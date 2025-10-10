--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Ubuntu 16.3-1.pgdg23.10+1)
-- Dumped by pg_dump version 16.3

-- Started on 2025-10-03 15:41:53

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
-- TOC entry 2 (class 3079 OID 16390)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16471)
-- Name: UA_Object; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."UA_Object" (
    id uuid NOT NULL,
    type_id uuid NOT NULL,
    object_name text NOT NULL,
    status_id uuid NOT NULL,
    purpose text,
    component_id uuid,
    create_date timestamp with time zone NOT NULL,
    create_by uuid,
    owner_user uuid,
    root_id uuid NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16476)
-- Name: component_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.component_type (
    id uuid NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 16978)
-- Name: diagram_object_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagram_object_relation (
    object_id uuid NOT NULL,
    diagram_id uuid NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16752)
-- Name: diagrams_chemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagrams_chemas (
    id uuid NOT NULL,
    diagram_id uuid NOT NULL,
    chema jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid NOT NULL,
    file_name text
);


--
-- TOC entry 247 (class 1259 OID 25434)
-- Name: diagrams_editors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagrams_editors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    diagram_id uuid NOT NULL,
    user_id uuid NOT NULL,
    edit_time timestamp without time zone DEFAULT now() NOT NULL,
    edit_type text
);


--
-- TOC entry 228 (class 1259 OID 16732)
-- Name: diagrams_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagrams_info (
    id uuid NOT NULL,
    creator_id uuid NOT NULL,
    title text NOT NULL,
    create_at timestamp with time zone NOT NULL,
    parent_id uuid,
    type_status_id uuid NOT NULL,
    root_id uuid NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 25358)
-- Name: diagrams_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagrams_status (
    id uuid NOT NULL,
    name text NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    is_first boolean DEFAULT false NOT NULL,
    background_color text DEFAULT ''::text NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 25406)
-- Name: diagrams_type_status_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagrams_type_status_relation (
    type_id uuid NOT NULL,
    status_id uuid NOT NULL,
    is_first boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- TOC entry 245 (class 1259 OID 25388)
-- Name: diagrams_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagrams_types (
    id uuid NOT NULL,
    name text NOT NULL,
    can_have_nested boolean DEFAULT false NOT NULL
);


--
-- TOC entry 248 (class 1259 OID 25457)
-- Name: integrations_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integrations_info (
    id uuid NOT NULL,
    protocol_id uuid,
    sender_object_id uuid,
    reciever_object_id uuid,
    description text,
    diagram_id uuid NOT NULL,
    creator uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    title text,
    schema_id uuid NOT NULL
);


--
-- TOC entry 249 (class 1259 OID 25472)
-- Name: integrations_protocols; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integrations_protocols (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    port_with_sec text,
    port_without_sec text,
    status_in_use boolean DEFAULT true NOT NULL,
    transport_layer_sec text DEFAULT 'Нет'::text NOT NULL
);


--
-- TOC entry 250 (class 1259 OID 33195)
-- Name: logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logs (
    "Message" text,
    "MessageTemplate" text,
    "Level" integer,
    "Timestamp" timestamp with time zone,
    "Exception" text,
    "LogEvent" jsonb
);


--
-- TOC entry 218 (class 1259 OID 16481)
-- Name: logs_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logs_history (
    id uuid NOT NULL,
    log_datetime timestamp with time zone NOT NULL,
    level text DEFAULT 'INFO'::text NOT NULL,
    log_message text NOT NULL,
    user_id uuid,
    parametrs json DEFAULT '[]'::json NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 25314)
-- Name: logs_object; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logs_object (
    id uuid NOT NULL,
    type text NOT NULL,
    old_value text,
    new_value text NOT NULL,
    user_id uuid NOT NULL,
    log_datetime timestamp with time zone DEFAULT now() NOT NULL,
    object_id uuid NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 16500)
-- Name: object_relations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.object_relations (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16503)
-- Name: object_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.object_status (
    id uuid NOT NULL,
    name text NOT NULL,
    description text,
    color text,
    isdeleted boolean DEFAULT false NOT NULL,
    isdisabled boolean DEFAULT false NOT NULL,
    for_diagram boolean DEFAULT false NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16508)
-- Name: object_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.object_tags (
    object_id uuid NOT NULL,
    tag_id uuid NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 16511)
-- Name: object_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.object_type (
    id uuid NOT NULL,
    type_name text NOT NULL,
    short_name text DEFAULT ''::text NOT NULL,
    back_color text DEFAULT ''::text NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone
);


--
-- TOC entry 237 (class 1259 OID 25222)
-- Name: property_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_info (
    id uuid NOT NULL,
    "Name" text NOT NULL,
    isenabled boolean DEFAULT true NOT NULL,
    createdby uuid NOT NULL,
    idpartition uuid NOT NULL,
    createdat timestamp with time zone NOT NULL,
    orderinpartition integer DEFAULT 0 NOT NULL,
    id_type uuid NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 25275)
-- Name: property_object_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_object_relation (
    idproperty uuid,
    idobject uuid NOT NULL,
    idvalue uuid NOT NULL,
    isdeleted boolean DEFAULT false NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 25213)
-- Name: property_partition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_partition (
    id uuid NOT NULL,
    title text NOT NULL,
    isenabled boolean DEFAULT true NOT NULL,
    createdby uuid NOT NULL,
    createdat timestamp with time zone,
    "order" integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 25232)
-- Name: property_partition_objecy_type_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_partition_objecy_type_relation (
    idpartition uuid NOT NULL,
    idobjtype uuid NOT NULL,
    createdby uuid NOT NULL,
    createdat timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 242 (class 1259 OID 25307)
-- Name: property_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_types (
    id uuid NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    ismulti boolean DEFAULT false NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 25249)
-- Name: property_value; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_value (
    id uuid NOT NULL,
    text_value text,
    createdby uuid NOT NULL,
    createdat timestamp with time zone DEFAULT now() NOT NULL,
    idproperty uuid NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 25256)
-- Name: property_value_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_value_history (
    idvalue uuid NOT NULL,
    text_value text,
    createdby uuid NOT NULL,
    createdat timestamp with time zone NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16536)
-- Name: role_object; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_object (
    role_id uuid NOT NULL,
    can_edit boolean DEFAULT false NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 16544)
-- Name: role_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_users (
    role_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16547)
-- Name: roles_model; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles_model (
    id uuid NOT NULL,
    description text,
    name text NOT NULL,
    iseditobject boolean DEFAULT false NOT NULL,
    iseditfolders boolean DEFAULT false NOT NULL,
    iseditdiagram boolean DEFAULT false NOT NULL,
    iseditintegrations boolean DEFAULT false NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 25154)
-- Name: status_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.status_relation (
    current_status uuid,
    next_status uuid NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 25193)
-- Name: status_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.status_relation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.status_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16552)
-- Name: tags_dictionary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags_dictionary (
    id uuid NOT NULL,
    name text NOT NULL,
    description text
);


--
-- TOC entry 227 (class 1259 OID 16557)
-- Name: type_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.type_relation (
    parent_type_id uuid,
    child_type_id uuid NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 25201)
-- Name: type_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.type_relation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.type_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 25167)
-- Name: type_status_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.type_status_relation (
    type uuid NOT NULL,
    status uuid NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 16971)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    full_name text NOT NULL
);


--
-- TOC entry 3417 (class 2606 OID 16566)
-- Name: UA_Object PK_object; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."UA_Object"
    ADD CONSTRAINT "PK_object" PRIMARY KEY (id);


--
-- TOC entry 3458 (class 2606 OID 16738)
-- Name: diagrams_info arch_schemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_info
    ADD CONSTRAINT arch_schemas_pkey PRIMARY KEY (id);


--
-- TOC entry 3423 (class 2606 OID 16568)
-- Name: component_type component_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_type
    ADD CONSTRAINT component_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3466 (class 2606 OID 16982)
-- Name: diagram_object_relation diagram_object_realtion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagram_object_relation
    ADD CONSTRAINT diagram_object_realtion_pkey PRIMARY KEY (diagram_id, object_id);


--
-- TOC entry 3500 (class 2606 OID 25442)
-- Name: diagrams_editors diagrams_editors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_editors
    ADD CONSTRAINT diagrams_editors_pkey PRIMARY KEY (id);


--
-- TOC entry 3461 (class 2606 OID 16758)
-- Name: diagrams_chemas diagrams_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_chemas
    ADD CONSTRAINT diagrams_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3494 (class 2606 OID 25365)
-- Name: diagrams_status diagrams_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_status
    ADD CONSTRAINT diagrams_status_pkey PRIMARY KEY (id);


--
-- TOC entry 3498 (class 2606 OID 25428)
-- Name: diagrams_type_status_relation diagrams_type_status_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_type_status_relation
    ADD CONSTRAINT diagrams_type_status_relation_pkey PRIMARY KEY (id);


--
-- TOC entry 3496 (class 2606 OID 25395)
-- Name: diagrams_types diagrams_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_types
    ADD CONSTRAINT diagrams_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3502 (class 2606 OID 25463)
-- Name: integrations_info integrations_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_info
    ADD CONSTRAINT integrations_info_pkey PRIMARY KEY (id);


--
-- TOC entry 3504 (class 2606 OID 33192)
-- Name: integrations_protocols integrations_protocols_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_protocols
    ADD CONSTRAINT integrations_protocols_name_key UNIQUE (name);


--
-- TOC entry 3506 (class 2606 OID 25480)
-- Name: integrations_protocols integrations_protocols_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_protocols
    ADD CONSTRAINT integrations_protocols_pkey PRIMARY KEY (id);


--
-- TOC entry 3425 (class 2606 OID 16570)
-- Name: logs_history logs_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs_history
    ADD CONSTRAINT logs_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3492 (class 2606 OID 25321)
-- Name: logs_object logs_object_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs_object
    ADD CONSTRAINT logs_object_pk PRIMARY KEY (id);


--
-- TOC entry 3429 (class 2606 OID 16572)
-- Name: object_relations obj_realtions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_relations
    ADD CONSTRAINT obj_realtions PRIMARY KEY (parent_id, child_id);


--
-- TOC entry 3433 (class 2606 OID 16578)
-- Name: object_status object_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_status
    ADD CONSTRAINT object_status_pkey PRIMARY KEY (id);


--
-- TOC entry 3438 (class 2606 OID 16580)
-- Name: object_type object_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_type
    ADD CONSTRAINT object_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3440 (class 2606 OID 25296)
-- Name: object_type object_type_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_type
    ADD CONSTRAINT object_type_unique UNIQUE (type_name);


--
-- TOC entry 3480 (class 2606 OID 25237)
-- Name: property_partition_objecy_type_relation partition_objecy_type_relation_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_partition_objecy_type_relation
    ADD CONSTRAINT partition_objecy_type_relation_pk PRIMARY KEY (idpartition, idobjtype);


--
-- TOC entry 3436 (class 2606 OID 16582)
-- Name: object_tags pk_obj_tags; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_tags
    ADD CONSTRAINT pk_obj_tags PRIMARY KEY (object_id, tag_id);


--
-- TOC entry 3478 (class 2606 OID 25269)
-- Name: property_info property_info_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_info
    ADD CONSTRAINT property_info_pk PRIMARY KEY (id);


--
-- TOC entry 3488 (class 2606 OID 25354)
-- Name: property_object_relation property_object_relation_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_object_relation
    ADD CONSTRAINT property_object_relation_pk PRIMARY KEY (idobject, idvalue);


--
-- TOC entry 3476 (class 2606 OID 25221)
-- Name: property_partition property_partition_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_partition
    ADD CONSTRAINT property_partition_pk PRIMARY KEY (id);


--
-- TOC entry 3490 (class 2606 OID 25313)
-- Name: property_types property_types_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_types
    ADD CONSTRAINT property_types_pk PRIMARY KEY (id);


--
-- TOC entry 3486 (class 2606 OID 25331)
-- Name: property_value_history property_value_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_value_history
    ADD CONSTRAINT property_value_history_pk PRIMARY KEY (idvalue, createdat);


--
-- TOC entry 3484 (class 2606 OID 25255)
-- Name: property_value property_value_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_value
    ADD CONSTRAINT property_value_pk PRIMARY KEY (id);


--
-- TOC entry 3443 (class 2606 OID 16592)
-- Name: role_object role_object_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_object
    ADD CONSTRAINT role_object_pkey PRIMARY KEY (role_id);


--
-- TOC entry 3445 (class 2606 OID 16596)
-- Name: role_users role_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_users
    ADD CONSTRAINT role_users_pkey PRIMARY KEY (user_id, role_id);


--
-- TOC entry 3447 (class 2606 OID 16598)
-- Name: roles_model roles_model_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_model
    ADD CONSTRAINT roles_model_pkey PRIMARY KEY (id);


--
-- TOC entry 3470 (class 2606 OID 25198)
-- Name: status_relation status_relation_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_relation
    ADD CONSTRAINT status_relation_pk PRIMARY KEY (id);


--
-- TOC entry 3472 (class 2606 OID 25200)
-- Name: status_relation status_relation_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_relation
    ADD CONSTRAINT status_relation_unique UNIQUE (current_status, next_status);


--
-- TOC entry 3450 (class 2606 OID 25298)
-- Name: tags_dictionary tags_dictionary_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags_dictionary
    ADD CONSTRAINT tags_dictionary_name_key UNIQUE (name);


--
-- TOC entry 3452 (class 2606 OID 16600)
-- Name: tags_dictionary tags_dictionary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags_dictionary
    ADD CONSTRAINT tags_dictionary_pkey PRIMARY KEY (id);


--
-- TOC entry 3454 (class 2606 OID 25206)
-- Name: type_relation type_relation_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_relation
    ADD CONSTRAINT type_relation_pk PRIMARY KEY (id);


--
-- TOC entry 3456 (class 2606 OID 25208)
-- Name: type_relation type_relation_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_relation
    ADD CONSTRAINT type_relation_unique UNIQUE (parent_type_id, child_type_id);


--
-- TOC entry 3474 (class 2606 OID 25183)
-- Name: type_status_relation type_status_relation_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_status_relation
    ADD CONSTRAINT type_status_relation_pk PRIMARY KEY (type, status);


--
-- TOC entry 3431 (class 2606 OID 16604)
-- Name: object_relations unq_childs; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_relations
    ADD CONSTRAINT unq_childs UNIQUE (child_id);


--
-- TOC entry 3464 (class 2606 OID 16977)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3418 (class 1259 OID 25456)
-- Name: UA_Object_root_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "UA_Object_root_id_idx" ON public."UA_Object" USING btree (root_id) WITH (deduplicate_items='true');


--
-- TOC entry 3481 (class 1259 OID 25352)
-- Name: fk_property_info; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_property_info ON public.property_value USING btree (idproperty);


--
-- TOC entry 3426 (class 1259 OID 16605)
-- Name: fki_FK_child_obj_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fki_FK_child_obj_id" ON public.object_relations USING btree (child_id);


--
-- TOC entry 3419 (class 1259 OID 16606)
-- Name: fki_FK_component_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fki_FK_component_id" ON public."UA_Object" USING btree (component_id);


--
-- TOC entry 3427 (class 1259 OID 16608)
-- Name: fki_FK_parent_obj_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fki_FK_parent_obj_id" ON public.object_relations USING btree (parent_id);


--
-- TOC entry 3420 (class 1259 OID 16610)
-- Name: fki_FK_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fki_FK_status_id" ON public."UA_Object" USING btree (status_id);


--
-- TOC entry 3434 (class 1259 OID 16611)
-- Name: fki_FK_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fki_FK_tag_id" ON public.object_tags USING btree (tag_id);


--
-- TOC entry 3421 (class 1259 OID 16612)
-- Name: fki_FK_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fki_FK_type_id" ON public."UA_Object" USING btree (type_id);


--
-- TOC entry 3467 (class 1259 OID 16994)
-- Name: fki_fk_diagram_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_diagram_id ON public.diagram_object_relation USING btree (diagram_id);


--
-- TOC entry 3459 (class 1259 OID 16751)
-- Name: fki_fk_folder; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_folder ON public.diagrams_info USING btree (parent_id);


--
-- TOC entry 3468 (class 1259 OID 16988)
-- Name: fki_fk_obj_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_obj_id ON public.diagram_object_relation USING btree (object_id);


--
-- TOC entry 3441 (class 1259 OID 16616)
-- Name: fki_fk_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_role_id ON public.role_object USING btree (role_id);


--
-- TOC entry 3462 (class 1259 OID 16781)
-- Name: idx_diag_hist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_diag_hist ON public.diagrams_chemas USING btree (diagram_id, created_at) WITH (deduplicate_items='true');


--
-- TOC entry 3448 (class 1259 OID 16619)
-- Name: idx_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_name_trgm ON public.tags_dictionary USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3482 (class 1259 OID 25387)
-- Name: idx_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_value ON public.property_value USING gin (text_value public.gin_trgm_ops);


--
-- TOC entry 3510 (class 2606 OID 16620)
-- Name: object_relations FK_child_obj_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_relations
    ADD CONSTRAINT "FK_child_obj_id" FOREIGN KEY (child_id) REFERENCES public."UA_Object"(id) NOT VALID;


--
-- TOC entry 3507 (class 2606 OID 16625)
-- Name: UA_Object FK_component_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."UA_Object"
    ADD CONSTRAINT "FK_component_id" FOREIGN KEY (component_id) REFERENCES public.component_type(id) NOT VALID;


--
-- TOC entry 3512 (class 2606 OID 16635)
-- Name: object_tags FK_object_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_tags
    ADD CONSTRAINT "FK_object_id" FOREIGN KEY (object_id) REFERENCES public."UA_Object"(id) NOT VALID;


--
-- TOC entry 3511 (class 2606 OID 16640)
-- Name: object_relations FK_parent_obj_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_relations
    ADD CONSTRAINT "FK_parent_obj_id" FOREIGN KEY (parent_id) REFERENCES public."UA_Object"(id) NOT VALID;


--
-- TOC entry 3508 (class 2606 OID 16655)
-- Name: UA_Object FK_status_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."UA_Object"
    ADD CONSTRAINT "FK_status_id" FOREIGN KEY (status_id) REFERENCES public.object_status(id) NOT VALID;


--
-- TOC entry 3513 (class 2606 OID 16660)
-- Name: object_tags FK_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.object_tags
    ADD CONSTRAINT "FK_tag_id" FOREIGN KEY (tag_id) REFERENCES public.tags_dictionary(id) NOT VALID;


--
-- TOC entry 3509 (class 2606 OID 16665)
-- Name: UA_Object FK_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."UA_Object"
    ADD CONSTRAINT "FK_type_id" FOREIGN KEY (type_id) REFERENCES public.object_type(id) NOT VALID;


--
-- TOC entry 3519 (class 2606 OID 25371)
-- Name: diagrams_chemas diagrams_chemas_diagram_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_chemas
    ADD CONSTRAINT diagrams_chemas_diagram_id_fkey FOREIGN KEY (diagram_id) REFERENCES public.diagrams_info(id) NOT VALID;


--
-- TOC entry 3536 (class 2606 OID 25443)
-- Name: diagrams_editors diagrams_editors_diagram_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_editors
    ADD CONSTRAINT diagrams_editors_diagram_id_fkey FOREIGN KEY (diagram_id) REFERENCES public.diagrams_info(id);


--
-- TOC entry 3537 (class 2606 OID 25448)
-- Name: diagrams_editors diagrams_editors_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_editors
    ADD CONSTRAINT diagrams_editors_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3517 (class 2606 OID 25382)
-- Name: diagrams_info diagrams_info_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_info
    ADD CONSTRAINT diagrams_info_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id) NOT VALID;


--
-- TOC entry 3518 (class 2606 OID 25429)
-- Name: diagrams_info diagrams_info_type_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_info
    ADD CONSTRAINT diagrams_info_type_status_id_fkey FOREIGN KEY (type_status_id) REFERENCES public.diagrams_type_status_relation(id) NOT VALID;


--
-- TOC entry 3534 (class 2606 OID 25416)
-- Name: diagrams_type_status_relation diagrams_type_status_relation_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_type_status_relation
    ADD CONSTRAINT diagrams_type_status_relation_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.diagrams_status(id);


--
-- TOC entry 3535 (class 2606 OID 25411)
-- Name: diagrams_type_status_relation diagrams_type_status_relation_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagrams_type_status_relation
    ADD CONSTRAINT diagrams_type_status_relation_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.diagrams_types(id);


--
-- TOC entry 3515 (class 2606 OID 16680)
-- Name: type_relation fk_child_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_relation
    ADD CONSTRAINT fk_child_id FOREIGN KEY (child_type_id) REFERENCES public.object_type(id);


--
-- TOC entry 3520 (class 2606 OID 16983)
-- Name: diagram_object_relation fk_obj_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagram_object_relation
    ADD CONSTRAINT fk_obj_id FOREIGN KEY (object_id) REFERENCES public."UA_Object"(id) NOT VALID;


--
-- TOC entry 3516 (class 2606 OID 16700)
-- Name: type_relation fk_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_relation
    ADD CONSTRAINT fk_parent_id FOREIGN KEY (parent_type_id) REFERENCES public.object_type(id);


--
-- TOC entry 3514 (class 2606 OID 16720)
-- Name: role_object fk_role_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_object
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES public.roles_model(id) NOT VALID;


--
-- TOC entry 3538 (class 2606 OID 41447)
-- Name: integrations_info integrations_info_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_info
    ADD CONSTRAINT integrations_info_creator_fkey FOREIGN KEY (creator) REFERENCES public.users(id) NOT VALID;


--
-- TOC entry 3539 (class 2606 OID 41417)
-- Name: integrations_info integrations_info_diagram_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_info
    ADD CONSTRAINT integrations_info_diagram_id_fkey FOREIGN KEY (diagram_id) REFERENCES public.diagrams_info(id) NOT VALID;


--
-- TOC entry 3540 (class 2606 OID 25481)
-- Name: integrations_info integrations_info_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_info
    ADD CONSTRAINT integrations_info_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.integrations_protocols(id) NOT VALID;


--
-- TOC entry 3541 (class 2606 OID 25491)
-- Name: integrations_info integrations_info_reciever_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_info
    ADD CONSTRAINT integrations_info_reciever_object_id_fkey FOREIGN KEY (reciever_object_id) REFERENCES public."UA_Object"(id) NOT VALID;


--
-- TOC entry 3542 (class 2606 OID 25486)
-- Name: integrations_info integrations_info_sender_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations_info
    ADD CONSTRAINT integrations_info_sender_object_id_fkey FOREIGN KEY (sender_object_id) REFERENCES public."UA_Object"(id) NOT VALID;


--
-- TOC entry 3527 (class 2606 OID 25243)
-- Name: property_partition_objecy_type_relation partition_objecy_type_relation_object_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_partition_objecy_type_relation
    ADD CONSTRAINT partition_objecy_type_relation_object_type_fk FOREIGN KEY (idobjtype) REFERENCES public.object_type(id);


--
-- TOC entry 3528 (class 2606 OID 25238)
-- Name: property_partition_objecy_type_relation partition_objecy_type_relation_property_partition_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_partition_objecy_type_relation
    ADD CONSTRAINT partition_objecy_type_relation_property_partition_fk FOREIGN KEY (idpartition) REFERENCES public.property_partition(id);


--
-- TOC entry 3525 (class 2606 OID 25270)
-- Name: property_info property_info_property_partition_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_info
    ADD CONSTRAINT property_info_property_partition_fk FOREIGN KEY (idpartition) REFERENCES public.property_partition(id);


--
-- TOC entry 3526 (class 2606 OID 25333)
-- Name: property_info property_info_property_types_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_info
    ADD CONSTRAINT property_info_property_types_fk FOREIGN KEY (id_type) REFERENCES public.property_types(id);


--
-- TOC entry 3531 (class 2606 OID 25285)
-- Name: property_object_relation property_object_relation_property_info_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_object_relation
    ADD CONSTRAINT property_object_relation_property_info_fk FOREIGN KEY (idproperty) REFERENCES public.property_info(id);


--
-- TOC entry 3532 (class 2606 OID 25290)
-- Name: property_object_relation property_object_relation_property_value_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_object_relation
    ADD CONSTRAINT property_object_relation_property_value_fk FOREIGN KEY (idvalue) REFERENCES public.property_value(id);


--
-- TOC entry 3533 (class 2606 OID 25280)
-- Name: property_object_relation property_object_relation_ua_object_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_object_relation
    ADD CONSTRAINT property_object_relation_ua_object_fk FOREIGN KEY (idobject) REFERENCES public."UA_Object"(id);


--
-- TOC entry 3530 (class 2606 OID 25263)
-- Name: property_value_history property_value_history_property_value_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_value_history
    ADD CONSTRAINT property_value_history_property_value_fk FOREIGN KEY (idvalue) REFERENCES public.property_value(id);


--
-- TOC entry 3529 (class 2606 OID 25347)
-- Name: property_value property_value_idproperty_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_value
    ADD CONSTRAINT property_value_idproperty_fkey FOREIGN KEY (idproperty) REFERENCES public.property_info(id) NOT VALID;


--
-- TOC entry 3521 (class 2606 OID 25157)
-- Name: status_relation status_relation_object_status_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_relation
    ADD CONSTRAINT status_relation_object_status_fk FOREIGN KEY (current_status) REFERENCES public.object_status(id);


--
-- TOC entry 3522 (class 2606 OID 25162)
-- Name: status_relation status_relation_object_status_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_relation
    ADD CONSTRAINT status_relation_object_status_fk_1 FOREIGN KEY (next_status) REFERENCES public.object_status(id);


--
-- TOC entry 3523 (class 2606 OID 25175)
-- Name: type_status_relation type_status_relation_object_status_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_status_relation
    ADD CONSTRAINT type_status_relation_object_status_fk FOREIGN KEY (status) REFERENCES public.object_status(id);


--
-- TOC entry 3524 (class 2606 OID 25170)
-- Name: type_status_relation type_status_relation_object_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.type_status_relation
    ADD CONSTRAINT type_status_relation_object_type_fk FOREIGN KEY (type) REFERENCES public.object_type(id);


-- Completed on 2025-10-03 15:41:57

--
-- PostgreSQL database dump complete
--

