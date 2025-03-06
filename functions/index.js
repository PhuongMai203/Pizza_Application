const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { OpenAI } = require("openai");

admin.initializeApp();
const db = admin.firestore();

// Cấu hình OpenAI API
const openai = new OpenAI({
  apiKey: functions.config().openai.key, // Sử dụng Firebase Environment Variables
});

exports.chatbotReply = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    try {
      const message = snap.data();
      if (message.sender === "bot") return;

      // Gửi tin nhắn đến OpenAI để nhận phản hồi
      const response = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: message.text }],
      });

      const botReply = response.choices[0].message.content;

      // Lưu phản hồi vào Firestore
      await db.collection("chats").doc(context.params.chatId)
        .collection("messages").add({
          sender: "bot",
          text: botReply,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
    } catch (error) {
      console.error("Lỗi:", error);
    }
  });