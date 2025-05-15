USE normalizationdb;

-- Question 1: Convert ProductDetail to 1NF
SELECT 
  OrderID, 
  CustomerName, 
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM ProductDetail
JOIN (
  SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
) numbers
ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n - 1
ORDER BY OrderID; -- sort by OrderID

-- Question 2: Convert OrderDetails to 2NF

-- Create the Orders table:
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(255)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;
SELECT * FROM Orders ORDER BY OrderID;-- Query for normalized Orders table:

-- Create the OrderDetails_2NF table:
CREATE TABLE OrderDetails_2NF (
  OrderID INT,
  Product VARCHAR(255),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
SELECT * FROM OrderDetails_2NF ORDER BY OrderID, Product;-- Query for normalized OrderDetails_2NF table:
