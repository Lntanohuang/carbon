# Price Lookup Skill (查价技能)

When a user asks about pricing for a specific customer and product/service,
follow this workflow:

1. **Identify the customer** — Search by name or alias using the
   `sales_getCustomers` MCP tool. Match fuzzy names.

2. **Identify the product/service** — Search using `items_getItems` tool.
   Match by name or category.

3. **Look up customer-specific price** — Use `sales_getCustomerItemPriceOverrides`
   to find the price override for this customer + item combination.
   If a spec is mentioned, match against the spec field.

4. **Fall back to default price** — If no customer-specific price exists,
   use the item's default price.

5. **Format response** — Always include:
   - Customer name
   - Product/service name
   - Spec (if applicable)
   - Price per unit (¥/米)
   - Whether this is a customer-specific or default price

## Example interactions:

User: "张总的304折弯多少钱一米"
→ Search customer "张总" → Find item "折弯" → Look up price with spec "304"
→ "张总（XX公司）的304折弯价格是 ¥X.XX/米（客户专属价格）"

User: "查一下李老板所有报价"
→ Search customer "李老板" → Get all price overrides for that customer
→ List all items and their prices

User: "新客户默认价格是多少"
→ List all items with their default prices
