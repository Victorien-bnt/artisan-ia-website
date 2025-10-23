<?php
// Configuration pour JSON
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Vérifie si le formulaire a été soumis
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = trim($_POST["name"] ?? '');
    $email = trim($_POST["email"] ?? '');
    $message = trim($_POST["message"] ?? '');
    
    // Validation des champs
    if (empty($name) || empty($email) || empty($message)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Tous les champs sont requis']);
        exit;
    }
    
    // Validation de l'email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Adresse email invalide']);
        exit;
    }
    
    // Limitation de la taille des champs
    if (strlen($name) > 100 || strlen($email) > 100 || strlen($message) > 1000) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Champs trop longs']);
        exit;
    }
    
    // Échapper les données pour éviter l'injection (sauf email pour l'envoi)
    $name = htmlspecialchars($name, ENT_QUOTES, 'UTF-8');
    $message = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
    // Email pas échappé pour l'envoi mais validé
    
    // Protection anti-spam simple
    $spam_words = ['viagra', 'casino', 'loan', 'credit', 'bitcoin', 'crypto'];
    $text_to_check = strtolower($name . ' ' . $email . ' ' . $message);
    
    foreach ($spam_words as $word) {
        if (strpos($text_to_check, $word) !== false) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Message rejeté']);
            exit;
        }
    }
    
    // Configuration de l'envoi
    $to = "victorienbinant@artisan-ia.fr";
    $subject = "Nouveau message depuis Artisan'IA - " . $name;
    $body = "Nom: $name\nEmail: $email\n\nMessage:\n$message";
    $headers = "From: victorienbinant@artisan-ia.fr\r\nReply-To: $email\r\n";
    
    // Envoi de l'email
    if (mail($to, $subject, $body, $headers)) {
        echo json_encode(['success' => true, 'message' => 'Message envoyé avec succès']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Erreur lors de l\'envoi']);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Méthode non autorisée']);
}
?>
