<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = htmlspecialchars($_POST["name"]);
    $email = htmlspecialchars($_POST["email"]);
    $message = htmlspecialchars($_POST["message"]);

    $to = "victorienbinant@artisan-ia.fr";
    $subject = "📩 Nouveau message depuis le site Artisan’IA";
    $body = "Nom: $name\nEmail: $email\n\nMessage:\n$message";
    $headers = "From: $email";

    if (mail($to, $subject, $body, $headers)) {
        echo "<p style='color:green'>✅ Message envoyé avec succès.</p>";
    } else {
        echo "<p style='color:red'>❌ Échec de l'envoi du message.</p>";
    }
}
?>
