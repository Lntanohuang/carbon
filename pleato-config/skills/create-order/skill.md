# Create Sales Order Skill (开单技能)

When a user wants to create a sales order through conversation:

1. **Identify customer** — Ask or detect which customer this order is for.
   Use `sales_getCustomers` to find and confirm.

2. **Add line items** — For each item:
   a. Identify the product/service
   b. Get the spec (material, thickness, angle, etc.)
   c. Look up customer-specific price (use price-lookup skill logic)
   d. Confirm quantity and unit
   e. Use `sales_upsertSalesOrderLine` to add

3. **Create the order** — Use `sales_upsertSalesOrder` with:
   - Customer ID
   - Order date (today by default)
   - Delivery address (from customer default or specified)
   - Payment terms

4. **Confirm with user** — Show order summary:
   - Order number
   - Customer
   - Line items with prices
   - Total amount
   - Payment terms

## Example:

User: "帮张总开个单，304折弯50米，201折弯30米"
→ Find customer "张总"
→ Find item "折弯"
→ Look up prices for spec "304" and "201"
→ Create order with 2 lines
→ "已为张总创建销售单 XS20260425XXXX：
   1. 304折弯 50米 × ¥X.XX = ¥XXX
   2. 201折弯 30米 × ¥X.XX = ¥XXX
   合计: ¥XXXX"
