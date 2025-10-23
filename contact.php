<?php
// --- Debug PHP ---
error_reporting(E_ALL);
ini_set('display_errors', 1);

// --- Vérifie si le formulaire a été soumis ---
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = htmlspecialchars($_POST["name"]);
    $email = htmlspecialchars($_POST["email"]);
    $message = htmlspecialchars($_POST["message"]);

    // --- Configuration de l'envoi ---
    $to = "victorienbinant@artisan-ia.fr";
    $subject = "?? Nouveau message depuis Artisan’IA";
    $body = "Nom: $name\nEmail: $email\n\nMessage:\n$message";
    $headers = "From: $email\r\n";
    $headers .= "Reply-To: $email\r\n";
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

    // --- Test de la fonction mail() ---
    if (mail($to, $subject, $body, $headers)) {
        echo "<p style='color:green;'>? Message envoyé avec succès à $to</p>";
    } else {
        echo "<p style='color:red;'>? Erreur lors de l’envoi du message.</p>";
        error_log('?? Échec de mail() pour : ' . $email);
    }
} else {
    echo "<p style='color:gray;'>?? Aucun formulaire soumis (méthode POST non détectée).</p>";
}
?>
