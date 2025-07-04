-- Q1: Find all raw materials provided by a specific supplier (by name)
SELECT rm.material_id, rm.unit_price, rm.quantity
FROM raw_materials rm
JOIN suppliers s ON rm.supplier_id = s.supplier_id
WHERE s.name = 'Supplier A1';

-- Q2: Calculate the total price of all orders from a specific supplier
SELECT o.suppliers_id, SUM(o.total_price) AS total_spent
FROM orders o
WHERE o.suppliers_id = (
    SELECT supplier_id FROM suppliers WHERE name = 'Supplier A1'
)
GROUP BY o.suppliers_id;

-- Q3: Insert a new supplier
INSERT INTO suppliers (supplier_id, name, email, phone_no)
VALUES (31, 'New Supplier', 'new@example.com', 1112223334);

-- Q4: Verify the inserted supplier
SELECT * FROM suppliers
WHERE supplier_id = 31;

-- Q5: Update the quantity of a specific raw material
UPDATE raw_materials
SET quantity = 100
WHERE material_id = 1 AND supplier_id = 1;

-- Q6: Verify updated raw material
SELECT * FROM raw_materials
WHERE material_id = 1;

-- Q7: Find all orders along with the supplier name
SELECT o.order_id, o.order_date, o.total_price, s.name AS supplier_name
FROM orders o
JOIN suppliers s ON o.suppliers_id = s.supplier_id;

-- Q8: List inventory items stored in a specific city
SELECT i.item_name, i.quantity, st.city_name
FROM inventory i
JOIN storage st ON i.storage_id = st.storage_id
WHERE st.city_name = 'City 1';

-- Q9: Find the total quantity of items ordered by each order
-- (Assumes contains_items_in table exists with orders_id, inventorys_id)
SELECT o.order_id, SUM(i.quantity) AS total_items
FROM orders o
JOIN contains_items_in ci ON o.order_id = ci.orders_id
JOIN inventory i ON ci.inventorys_id = i.inventory_id
GROUP BY o.order_id;

-- Q10: Delete a supplier
DELETE FROM suppliers
WHERE supplier_id = 31;

-- Q11: Show shipments planned for a specific destination
SELECT shipment_id, ship_date, transport_method
FROM shipment
WHERE destination = 'Destination A';

-- Q12: List all orders, item names, and quantities for each supplier
-- (Assumes contains_items_in table exists)
SELECT 
    s.supplier_id,
    s.name AS supplier_name,
    o.order_id,
    i.item_name,
    SUM(i.quantity) AS total_quantity
FROM suppliers s
JOIN orders o ON s.supplier_id = o.suppliers_id
JOIN contains_items_in ciin ON o.order_id = ciin.orders_id
JOIN inventory i ON ciin.inventorys_id = i.inventory_id
GROUP BY s.supplier_id, s.name, o.order_id, i.item_name
ORDER BY s.supplier_id, o.order_id;

-- Q13: Rank suppliers based on the total price of orders
SELECT 
    s.supplier_id,
    s.name,
    SUM(o.total_price) OVER (PARTITION BY s.supplier_id) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_price) DESC) AS spending_rank
FROM suppliers s
JOIN orders o ON s.supplier_id = o.suppliers_id
GROUP BY s.supplier_id, s.name, o.total_price
ORDER BY total_spent DESC;

-- Q14: Find the top 3 most stocked items in each storage facility
WITH RankedItems AS (
    SELECT 
        storage_id,
        item_name,
        quantity,
        RANK() OVER (PARTITION BY storage_id ORDER BY quantity DESC) AS rank
    FROM inventory
)
SELECT storage_id, item_name, quantity, rank
FROM RankedItems
WHERE rank <= 3;

-- Q15: Calculate average unit price of raw materials per supplier
SELECT 
    s.name AS supplier_name,
    AVG(rm.unit_price) AS avg_unit_price
FROM raw_materials rm
JOIN suppliers s ON rm.supplier_id = s.supplier_id
GROUP BY s.name;

-- Q16: List shipments that include items from more than one storage location
WITH ShipmentDetails AS (
    SELECT sh.shipment_id, inv.storage_id
    FROM shipment sh
    JOIN shipment_item si ON sh.shipment_id = si.shipment_id
    JOIN inventory inv ON si.invent_id = inv.inventory_id
    GROUP BY sh.shipment_id, inv.storage_id
)
SELECT shipment_id
FROM ShipmentDetails
GROUP BY shipment_id
HAVING COUNT(DISTINCT storage_id) > 1;
