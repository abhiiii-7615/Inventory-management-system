-- Table 1: Suppliers
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(20),
    email VARCHAR(20),
    phone_no INT
);
-- Table 2: Raw Materials
CREATE TABLE raw_materials (
    material_id INT NOT NULL,
    unit_price INT,
    quantity INT,
    supplier_id INT,
    PRIMARY KEY(material_id, supplier_id),
    CONSTRAINT fk_supplier_id FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);
-- Table 3: Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    total_price INT,
    suppliers_id INT,
    CONSTRAINT fk_suppliers_id FOREIGN KEY (suppliers_id) REFERENCES suppliers(supplier_id)
);
-- Table 4: Storage
CREATE TABLE storage (
    storage_id INT PRIMARY KEY,
    pincode INT,
    land_mark VARCHAR(20),
    city_name VARCHAR(20)
);
-- Table 5: Inventory
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    item_name VARCHAR(20),
    quantity INT,
    storage_id INT,
    CONSTRAINT fk_storage_id FOREIGN KEY (storage_id) REFERENCES storage(storage_id)
);
-- Table 6: Items
CREATE TABLE items (
    item_id INT PRIMARY KEY,
    description VARCHAR(20),
    category VARCHAR(20),
    name VARCHAR(20)
);
-- Table 7: Hold Item (Mapping Inventory and Items)
CREATE TABLE hold_item (
    inventory_id INT,
    item_id INT,
    PRIMARY KEY(inventory_id, item_id),
    CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES items(item_id),
    CONSTRAINT fk_inventory_id FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);
-- Table 8: Shipment
CREATE TABLE shipment (
    shipment_id INT PRIMARY KEY,
    ship_date DATE,
    transport_method VARCHAR(50),
    destination VARCHAR(50)
);
-- Table 9: Shipment Item (Mapping Inventory and Shipment)
CREATE TABLE shipment_item (
    shipment_item_id INT NOT NULL,
    invent_id INT,
    shipment_id INT,
    PRIMARY KEY(shipment_item_id, invent_id, shipment_id),
    CONSTRAINT fk_invent_id FOREIGN KEY (invent_id) REFERENCES inventory(inventory_id),
    CONSTRAINT fk_shipment_id FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id)
);
