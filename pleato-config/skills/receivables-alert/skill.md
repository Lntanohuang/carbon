# Receivables Alert Skill (应收提醒技能)

Check for overdue receivables and notify via configured messaging gateway.

## Trigger
- Cron schedule: daily at 9:00 AM
- Or on-demand when user asks about receivables

## Workflow

1. **Query all customers** with totalUnpaid > 0 using `sales_getCustomers`
2. **For each customer**, check if paymentCycleDays has been exceeded:
   - Get unpaid orders using `sales_getSalesOrders` with status "delivered"
   - Compare delivery date + paymentCycleDays against today
3. **Generate alert summary** grouped by urgency:
   - 🔴 Overdue > 30 days
   - 🟡 Overdue 1-30 days
   - 🟢 Due within this week
4. **Send notification** via configured gateway (WeChat/Feishu/Telegram)

## Response format:

应收账款提醒 (2026-04-25):

🔴 严重超期 (>30天):
- 张总 (XX公司): ¥15,000 | 超期45天
- 李老板 (YY公司): ¥8,200 | 超期32天

🟡 一般超期 (1-30天):
- 王经理 (ZZ厂): ¥3,500 | 超期12天

🟢 本周到期:
- 赵总 (AA公司): ¥6,000 | 3天后到期

合计应收: ¥32,700
