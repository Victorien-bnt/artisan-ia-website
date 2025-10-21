# Artisan'IA - Site Vitrine

Site vitrine moderne et responsive pour Artisan'IA, une solution d'intelligence artisanale qui automatise la gestion quotidienne des artisans et TPE.

## 🎯 Caractéristiques

- **Design moderne** : Style Apple/Linear/Notion avec une esthétique minimaliste
- **Responsive** : Optimisé pour tous les appareils (mobile-first)
- **Performance** : Chargement rapide avec optimisations avancées
- **Accessibilité** : Conforme aux standards d'accessibilité web
- **SEO optimisé** : Meta tags et structure sémantique

## 🚀 Technologies utilisées

- **HTML5** : Structure sémantique moderne
- **Tailwind CSS** : Framework CSS utilitaire
- **JavaScript ES6+** : Interactions et animations
- **SVG** : Icônes vectorielles optimisées
- **Intersection Observer** : Animations au scroll
- **Formspree** : Gestion des formulaires

## 📁 Structure du projet

```
artisan-ia-website/
├── index.html              # Page principale
├── style.css               # Styles personnalisés
├── tailwind.config.js      # Configuration Tailwind
├── js/
│   └── main.js            # Scripts et interactions
├── assets/
│   ├── images/
│   │   ├── Logo Artisan'IA4.svg
│   │   ├── mockup-dashboard.png
│   │   └── og-image.jpg
│   └── icons/
│       ├── favicon.svg
│       ├── invoice.svg
│       ├── stock.svg
│       ├── whatsapp.svg
│       ├── dashboard.svg
│       ├── arrow-down.svg
│       └── check.svg
└── README.md
```

## 🎨 Sections du site

1. **Header** : Navigation fixe avec logo et menu
2. **Hero** : Section d'accueil avec titre principal et CTA
3. **Fonctionnalités** : 4 cartes présentant les principales fonctionnalités
4. **Pourquoi** : Section de valeur avec logos partenaires
5. **Témoignage** : Citation client
6. **Contact** : Formulaire et bouton WhatsApp
7. **Footer** : Informations légales

## ⚙️ Configuration

### Formspree
Pour activer le formulaire de contact, remplacez `YOUR_FORM_ID` dans `index.html` par votre ID Formspree.

### WhatsApp
Modifiez le numéro de téléphone dans le lien WhatsApp :
```html
href="https://wa.me/336XXXXXXXX?text=..."
```

## 🚀 Déploiement

### Docker/Nginx
Le site est prêt pour un déploiement statique via Docker :

```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### VPS
Copiez tous les fichiers dans `/home/ubuntu/artisan-ia-website` et servez via Nginx.

## 🎯 Optimisations

- **Images lazy loading** : Chargement différé des images
- **Animations performantes** : Utilisation de `transform` et `opacity`
- **Throttling** : Limitation des événements scroll
- **Preload** : Préchargement des ressources critiques
- **Service Worker** : Support PWA (préparé)

## 📱 Responsive Design

- **Mobile** : < 768px
- **Tablet** : 768px - 1024px
- **Desktop** : > 1024px

## ♿ Accessibilité

- Navigation au clavier
- Skip links
- ARIA labels
- Contraste respecté
- Support lecteurs d'écran

## 🔧 Personnalisation

### Couleurs
Modifiez les couleurs dans `tailwind.config.js` :
```javascript
colors: {
  primary: {
    // Vos couleurs personnalisées
  }
}
```

### Animations
Ajustez les animations dans `style.css` et `main.js`.

### Contenu
Modifiez le contenu directement dans `index.html`.

## 📞 Support

Pour toute question ou personnalisation, contactez l'équipe de développement.

---

© 2025 Artisan'IA - Tous droits réservés.
