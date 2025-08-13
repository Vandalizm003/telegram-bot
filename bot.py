from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
import datetime

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Привіт! Я бот Glory Project. Напиши /info щоб дізнатися більше.")

async def info(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Цей бот створений для тестування проєкту Glory. Скоро буде більше функцій!")

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "Доступні команди:\n"
        "/start — почати роботу з ботом\n"
        "/info — інформація про бота\n"
        "/help — список команд\n"
        "/echo <текст> — повторити ваше повідомлення\n"
        "/time — поточний час\n"
        "/about — про автора"
    )

async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if context.args:
        await update.message.reply_text(' '.join(context.args))
    else:
        await update.message.reply_text("Введіть текст після команди /echo.")

async def time(update: Update, context: ContextTypes.DEFAULT_TYPE):
    now = datetime.datetime.now().strftime("%d.%m.%Y %H:%M:%S")
    await update.message.reply_text(f"Зараз {now}")

async def about(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Автор: Glory Project Team. Зв'язок: @yourusername")

app = ApplicationBuilder().token("8374780966:AAF7pRNJwxEBbJYa4J3gPumVPOSq944KPuU").build()

app.add_handler(CommandHandler("start", start))
app.add_handler(CommandHandler("info", info))
app.add_handler(CommandHandler("help", help_command))
app.add_handler(CommandHandler("echo", echo))
app.add_handler(CommandHandler("time", time))
app.add_handler(CommandHandler("about", about))

app.run_polling()