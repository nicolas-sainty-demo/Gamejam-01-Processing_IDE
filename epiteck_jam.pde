
import processing.sound.*;
SoundFile file;

///////////////////////////////
// declaration des variables//
//////////////////////////////

float xPosJoueur1,yPosJoueur1,xPosOrigineJoueur1,yPosOrigineJoueur1,speed,gravity,t,vitesse,angle,enlair; 
float xPosJoueur2,yPosJoueur2,xPosOrigineJoueur2,yPosOrigineJoueur2,speed1,gravity1,t1,vitesse1,angle1,enlair1;
float xPosJoueur3,yPosJoueur3,xPosOrigineJoueur3,yPosOrigineJoueur3,speed2,gravity2,t2,vitesse2,angle2,enlair2;


int hitJ1, nbEjectionJoueur1; //score Joueur 2
int hitJ2, nbEjectionJoueur2; //score Joueur 1
int hitJ3; //score Bot
int i =1;                     //déclaration variable de boucle pour le grow

              //déclaration des images du décor
PImage Decor, Decoropaque, Decorgameover, EcranTitre;
PImage[] nyancat = new PImage[8];
int count = 0;
int image = 0;
              //Déclaration des variables pour créer un effet glow autour des balles
color couleurjoueur2, couleurjoueur1, couleurHit, couleurjoueur3;

              //Déclaration et Init d'un set de couleur
color blanc= color(255), red= color(255,0,0), cian =color(8,255,242), orange= color(240, 100, 0), violet=color(205,98,213),violet2=color(147,147,214);

              //Déclaration des variables des effets visuels
float rMin = 25;              //rayon minimum d'une balle
float rMax = 30;              //rayon maximum d'une balle
float r = rMin;               //rayon d'une la balle
boolean grow = true;          //etant croissance du diametre.
int rGlow;                    //rayon de croisance

            //Déclaration des polices
PFont police;
            //Déclaration d'un booleen EcranTitre
Boolean ecranTitre= true;


// pour des besoin d'angle de frappe ainsi que du test de collision, il nous faut transformer les coordonnées des centre des ellipse joueurs 1 et joueur 2 en vecteur.
//il existe une fonction PVector qui possede justement deux methode adéquate.
//déclaration de deux vecteurs pour les joueurs 1 et 2 et d'un troisieme vecteur v1v2 qui est le vecteur extrait des positions relatives
//des deux joueurs. Pour avoir un vecteur " opposé" v2v1, il sufit ajouter Pi a l'angle en radian de v1v2. faisons donc l'économie 
// de la création d'un quatrieme vecteur.

PVector vjoueur1, vjoueur2, vjoueur3, v1v3, v2v3;
int score, printscore;


void setup() {
  
  frameRate(60);              //Nombre de draw max par seconde
  size(1920, 1080);           //taille de la fenetre
  ellipseMode(RADIUS);        //argument des ellipses en radian
  smooth();                   //activation du lissage de l'image
  background(0);              //couleur de fond en noir. Joue sur la visibilité de la trainée
  //fullScreen();

  //////////////////////////////////
  //Chargement des images de décor//
  //////////////////////////////////
  
  background(0);
  Decor        = loadImage("decor.png");
  Decoropaque  = loadImage("decoropaque.png");
  Decorgameover= loadImage("decorgameover.png");
  image(Decor,0,0);           //affiche le decor ( image affichée une fois dans le setup)
  EcranTitre=    loadImage("Ecrantitre.png");
  
  nyancat[0] = loadImage("n1.png");
  nyancat[1] = loadImage("n2.png");
  nyancat[2] = loadImage("n3.png");
  nyancat[3] = loadImage("n4.png");
  nyancat[4] = loadImage("n5.png");
  nyancat[5] = loadImage("n6.png");
  nyancat[6] = loadImage("n7.png");
  nyancat[7] = loadImage("n8.png");
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Chargement de la Police choisie pour afficher le texte et utiliser text(). Trouvé sur wiki processing//
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  police= loadFont("Bauhaus93.vlw");
  
  //////////////////////////////////////////
  //Parametrage des variables du joueur 1 //
  //////////////////////////////////////////
  

  xPosJoueur1 = 100;          //Position en X du joueur.l'origine du repere est le coin haut gauche de la fenetre
  yPosJoueur1 =200;           //Position en Y du joueur.l'origine du repere est le coin haut gauche de la fenetre
  xPosOrigineJoueur1=100;     //Variable de Stockage de la position d'origine du saut
  yPosOrigineJoueur1=200;     //Variable de stockage de la position d'origine du saut
  vitesse = -20;              //vitesse initiale durant les saut. Est incrémenté lorsque l'on recoit un coup.
  gravity = 8;                //influence la vitesse de chute du joueur.
  t=0;                        //variable de temps neccessaire à l'équation de trajectoire
  angle=15 ;                  //angle du saut lors du déplacement de base
  couleurjoueur1 = cian;      //choix possible blanc,rouge cian, orange, violet,violet2
  nbEjectionJoueur1 = 0;      //Score de base. Peut servir de Handicap
  
  //////////////////////////////////////////
  //Parametrage des variables du joueur 2 //
  //////////////////////////////////////////
  
  xPosJoueur2 = 1880;         //Position en X du joueur.l'origine du repere est le coin haut gauche de la fenetre
  yPosJoueur2 =200;           //Position en Y du joueur.l'origine du repere est le coin haut gauche de la fenetre
  xPosOrigineJoueur2=1880;    //Variable de stockage de la position d'origine du saut
  yPosOrigineJoueur2=200;     //Variable de stockage de la position d'oringine du saut
  vitesse1 = 20;              //vitesse initiale durant les saut. Est incrémenté lorsque l'on recoit un coup. son signe oriente la balle vers la gauche
  gravity1 = 8;               //influence la vitesse de chute du joueur.
  t1=0;                       //variable de temps neccessaire à l'équation de trajectoire
  angle1=-15 ;                //angle du saut lors du déplacement de base
  couleurjoueur2= orange;     //choix possible blanc,rouge,orange,cian,violet, violet2
  nbEjectionJoueur2 = 0;      //Score de base. Peut servir de Handicap
  
  
  //////////////////////////////////////////
  //Parametrage des variables de l'IA     //
  //////////////////////////////////////////
  
  xPosJoueur3 = 910;          //Position en X du joueur.l'origine du repere est le coin haut gauche de la fenetre
  yPosJoueur3 =400;           //Position en Y du joueur.l'origine du repere est le coin haut gauche de la fenetre
  xPosOrigineJoueur3=910;    //Variable de stockage de la position d'origine du saut
  yPosOrigineJoueur3=400;     //Variable de stockage de la position d'oringine du saut
  vitesse2 = -60;              //vitesse initiale durant les saut. Est incrémenté lorsque l'on recoit un coup. son signe oriente la balle vers la gauche
  gravity2 = 8;               //influence la vitesse de chute du joueur.
  t2=0;                       //variable de temps neccessaire à l'équation de trajectoire
  angle2=PI/2 ;                //angle du saut lors du déplacement de base
  couleurjoueur3= red;     //choix possible blanc,rouge,orange,cian,violet, violet2

  ///////////////////////////////////////
  //Parametrage commun au deux joueurs //
  ///////////////////////////////////////
  
  couleurHit = red;           //Couleur que prend la balle si l'on est en train de taper
  rGlow=10;                   //Rayon de l'effet de Glow
  grow = true;                //Initialisation du booleen de l'etat de croissance de la balle
  frameRate(60);              //Initialisation du framerate
  score = 0;
  printscore = 0;
  file = new SoundFile(this, "nyancat.mp3");
  file.loop();
}

void draw() {
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Affiche une copie du decor dont on a diminué l'opacité afin de voir un effet de traine de la balle  //
  //condition pour afficher le message game over                                                        //
  //condition pour afficher le score                                                                    //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  if (xPosJoueur1 < 0 || xPosJoueur1 > width || yPosJoueur1<0 || yPosJoueur1>1080)
     {
          nbEjectionJoueur1 = nbEjectionJoueur1+1;
          image(Decoropaque,0,0);
          textFont(police);
     }
  else
     {    image(Decoropaque,0,0);   }
     
  if (xPosJoueur2 < 0 || xPosJoueur2 > width || yPosJoueur2<0 || yPosJoueur2>1080)
     {
          nbEjectionJoueur2 = nbEjectionJoueur2+1;
          textFont(police);
          image(Decoropaque,0,0);
     }
  else
     {    image(Decoropaque,0,0);  }
     
  count++;
  if (count == 5) {
    count = 0;
    image++;
  }
  if (image == 8) {
    image  = 0;
  }
  image(nyancat[image], (nbEjectionJoueur1 + nbEjectionJoueur2) * 7, 0);
  if (((nbEjectionJoueur1 + nbEjectionJoueur2) * 7) < 1920) {
      score = score + 1;
      if (score == 60) {
        score = 0;
      printscore = printscore + 1;}
      if (!ecranTitre) { text( str(printscore), ((nbEjectionJoueur1 + nbEjectionJoueur2) * 7) - 100, 120);}
  } else {
    text( str(printscore),1820, 120);
  }
  
  ///////////////////////////
  //incrémentation du temps//
  ///////////////////////////
  
  t=t+0.5;
  t1=t1+0.5;
  t2=t2+0.5;
  
  ////////////////////////////////////////
  //Affichage  de la balle du joueur 1  //
  ////////////////////////////////////////
  
  stroke  (couleurjoueur1);
  fill    (couleurjoueur1);
  ellipse (xPosJoueur1, yPosJoueur1, r, r);

  ////////////////////////////////////////////////////////////////
  //Création d'un effet de glow autour de la balle du joueur1   //
  //inclusion d'une condition HitJ1 pour changer la couleur     //
  ////////////////////////////////////////////////////////////////
  
     noFill();
     for (int i = 1; i < rGlow; i++)
         { if (hitJ1==1) { stroke(red(couleurHit), green(couleurHit), blue(couleurHit),255/i);}
           else          { stroke(red(couleurjoueur1), green(couleurjoueur1), blue(couleurjoueur1), 255/i);}
           strokeWeight(2);
           ellipse(xPosJoueur1, yPosJoueur1, r+i, r+i);
         }
 ////////////////////////////////////////////////////////////////////////////
 //Création d'un effet visuel de type pulsation qui fait grandir           //
 //le rayon puis le diminue en fonction des parametres rayon Max rayon Min //
 ////////////////////////////////////////////////////////////////////////////
 
 if ( grow ) 
         { r += 8/frameRate;
           if ( r > rMax ) grow = false;
         }
 else    { r -= 8/frameRate;
           if ( r < rMin ) grow = true;
         }
  //////////////////////////////////////////
  //Affichage de la balle du joueur2     //
  /////////////////////////////////////////
  
  stroke(couleurjoueur2);
  fill(couleurjoueur2);
  ellipse(xPosJoueur2, yPosJoueur2, r, r);
  
  //////////////////////////////////////////////////////////////
  //création d'un effet de glow autour de la balle du joueur2 //
  //////////////////////////////////////////////////////////////
  
  noFill();
     for (int i = 1; i < rGlow; i++)
         { if (hitJ2==1) { stroke(red(couleurHit), green(couleurHit), blue(couleurHit),255/i);}
           else          { stroke(red(couleurjoueur2), green(couleurjoueur2), blue(couleurjoueur2), 255/i);}
           strokeWeight(2);
           ellipse(xPosJoueur2, yPosJoueur2, r+i, r+i);
         }
 ////////////////////////////////////////////////////////////////////////////
 //Création d'un effet visuel de type pulsation qui fait grandir           //
 //le rayon puis le diminue en fonction des parametres rayon Max rayon Min //
 ////////////////////////////////////////////////////////////////////////////
 
 if ( grow ) 
         { r += 8/frameRate;
           if ( r > rMax ) grow = false;
         }
 else    { r -= 8/frameRate;
           if ( r < rMin ) grow = true;
         }
  

  ////////////////////////////////////////
  //Affichage  de la balle de lia       //
  ////////////////////////////////////////
  
  stroke  (couleurjoueur3);
  fill    (couleurjoueur3);
  ellipse (xPosJoueur3, yPosJoueur3, r, r);

  ////////////////////////////////////////////////////////////////
  //Création d'un effet de glow autour de la balle de l'ia      //
  //inclusion d'une condition HitJ1 pour changer la couleur     //
  ////////////////////////////////////////////////////////////////
  
     noFill();
     for (int i = 1; i < rGlow; i++)
         { if (hitJ3==1) { stroke(red(couleurHit), green(couleurHit), blue(couleurHit),255/i);}
           else          { stroke(red(couleurjoueur1), green(couleurjoueur1), blue(couleurjoueur1), 255/i);}
           strokeWeight(2);
           ellipse(xPosJoueur3, yPosJoueur3, r+i, r+i);
         }
 ////////////////////////////////////////////////////////////////////////////
 //Création d'un effet visuel de type pulsation qui fait grandir           //
 //le rayon puis le diminue en fonction des parametres rayon Max rayon Min //
 ////////////////////////////////////////////////////////////////////////////
 
 if ( grow ) 
         { r += 8/frameRate;
           if ( r > rMax ) grow = false;
         }
 else    { r -= 8/frameRate;
           if ( r < rMin ) grow = true;
         }

  ///////////////////////////////////////////////////////////////////////////////
  // Calcul des coordonnées x,y du joueur 1. S'appuie sur une boucle de temps  //
  // que l'on réinitialise à chaque debut de saut.                             //
  ///////////////////////////////////////////////////////////////////////////////

  if (ecranTitre == false)
  {
    yPosJoueur1=      0.5*gravity*t*t+sin(angle)*vitesse*t+yPosOrigineJoueur1;
    xPosJoueur1=      cos(angle)*vitesse*t+xPosOrigineJoueur1;
    gravity    =      8;
    enlair     =      1;
  }

  ///////////////////////////////////////////////////////////////////////////////
  // Calcul des coordonnées x,y du joueur 2. S'appuie sur une boucle de temps  //
  // que l'on réinitialise à chaque debut de saut.                             //
  ///////////////////////////////////////////////////////////////////////////////
  
  if (ecranTitre == false)
  {
    yPosJoueur2=      0.5*gravity1*t1*t1+sin(angle1)*vitesse1*t1+yPosOrigineJoueur2;
    xPosJoueur2=      cos(angle1)*vitesse1*t1+xPosOrigineJoueur2;
    gravity1   =      8;
    enlair1    =      1;
  }

  ///////////////////////////////////////////////////////////////////////////////
  // Calcul des coordonnées x,y de l'ia. S'appuie sur une boucle de temps      //
  // que l'on réinitialise à chaque debut de saut.                             //
  ///////////////////////////////////////////////////////////////////////////////
  
  if (ecranTitre == false)
  {
    yPosJoueur3=      0.5*gravity2*t2*t2+sin(angle2)*vitesse2*t2+yPosOrigineJoueur3;
    xPosJoueur3=      cos(angle2)*vitesse2*t2+xPosOrigineJoueur3;
    gravity1   =      8;
    enlair1    =      1;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////
  //Transformation des coordonnées des joueurs 1 et 2 en vecteur afin de pouvoir utiliser   //
  //les methodes dist() et heading().                                                       //
  ////////////////////////////////////////////////////////////////////////////////////////////
  
  vjoueur1  =      new PVector(xPosJoueur1,yPosJoueur1);
  vjoueur2  =      new PVector(xPosJoueur2,yPosJoueur2);
  vjoueur3  =      new PVector(xPosJoueur3,yPosJoueur3);
  v1v3      =      new PVector(xPosJoueur3-xPosJoueur1,yPosJoueur3-yPosJoueur1);
  v2v3      =      new PVector(xPosJoueur3-xPosJoueur2,yPosJoueur3-yPosJoueur2);
  
  float distancev1v3=PVector.dist(vjoueur1,vjoueur3);
  //println("distance",distancev1v3);
  float anglev1v3=v1v3.heading();
  //println("angle de frappe",anglev1v2);
  float distancev2v3=PVector.dist(vjoueur2,vjoueur3);
  //println("distance",distancev2v3);
  float anglev2v3=v2v3.heading();
  //println("angle de frappe",anglev2v3);

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Reussite d'un coup porté entre balle 1 est 2 basé sur la distance entre le vecteur v1 et le vecteur v2.//
  //l'angle de frappe est égal a l'angle en radian du vecteur v1v2 ou v1v2 + PI. c'est a dire son opposé.  //
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (hitJ3==1 && distancev2v3<2*rMax) { angle1=anglev1v3;
                                         t1=0;
                                         vitesse1=-100;  }
                                       
  if (hitJ3==1 && distancev1v3<2*rMax) { angle=anglev2v3;
                                         t=0;
                                         vitesse=-100;   }

  ////////////////////////////////////////////
  //Affiche les images ecrans et les boutons//
  ////////////////////////////////////////////
  
  if (ecranTitre) {image(EcranTitre,0,0);}
  
  if (((nbEjectionJoueur1 + nbEjectionJoueur2) * 7) > 1920)
        {image(Decorgameover,0,0);}
        
  /////////////////////////////////
  //Code de déplacement de l'IA  //
  /////////////////////////////////
  
 if (yPosJoueur3 > 1000 || yPosOrigineJoueur3 < 100 || xPosOrigineJoueur3 < 0 || xPosOrigineJoueur3 > 1920) {
     if (yPosJoueur3 > 1000){
                    angle2=PI/2;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
     }
     else if (yPosOrigineJoueur3 < 100 ) {
       
     }
     else if (xPosOrigineJoueur3 < 0) {
                    angle2=2*PI/3;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
     }
     else if (xPosOrigineJoueur3 > 1920) {
                    angle2=PI/3;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
     }
 }
 else if (distancev1v3 < distancev2v3) {
    if (xPosOrigineJoueur1 > xPosOrigineJoueur3 && yPosOrigineJoueur3 > yPosOrigineJoueur1) {
                    angle2=2*PI/3;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
    } else if (xPosOrigineJoueur1 < xPosOrigineJoueur3 && yPosOrigineJoueur3 > yPosOrigineJoueur1) {
                    angle2=PI/3;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
    }
  }
  else if (distancev1v3 > distancev2v3) {
    if (xPosOrigineJoueur2 > xPosOrigineJoueur3 && yPosOrigineJoueur3 > yPosOrigineJoueur2) {
                    angle2=2*PI/3;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
    } else if (xPosOrigineJoueur2 < xPosOrigineJoueur3 && yPosOrigineJoueur3 > yPosOrigineJoueur1) {
                    angle2=PI/3;
                    vitesse2=-50;
                    t2=0;
                    yPosOrigineJoueur3=yPosJoueur3;
                    xPosOrigineJoueur3=xPosJoueur3;
                    hitJ3=0;
    }
  }
  if (distancev1v3<2*rMax || distancev2v3<2*rMax) {
    hitJ3 = 1;
  }
  
  
}

void keyPressed() {
  if (keyPressed==true) {

    if (key=='q') { 
                    angle1=PI/3;
                    vitesse1=-50;
                    t1=0;
                    yPosOrigineJoueur2=yPosJoueur2;
                    xPosOrigineJoueur2=xPosJoueur2;
                    hitJ2=0;
                  }
    if (key=='d') { 
                    angle1=2*PI/3;
                    vitesse1=-50;
                    t1=0;
                    yPosOrigineJoueur2=yPosJoueur2;
                    xPosOrigineJoueur2=xPosJoueur2;
                    hitJ2=0;

                  }
      
    if (key=='z') { angle1=PI/2;
                    vitesse1=-50;
                    t1=0;
                    yPosOrigineJoueur2=yPosJoueur2;
                    xPosOrigineJoueur2=xPosJoueur2;
                    hitJ2=0;
                  }
      
    if (key=='s'){ hitJ2=0;}
      
    
    if (key == CODED) {
        if (keyCode==LEFT) 
                 { angle=PI/3;
                   vitesse=-50;
                   t=0;
                   yPosOrigineJoueur1=yPosJoueur1;
                   xPosOrigineJoueur1=xPosJoueur1;
                   hitJ1=0;
                 }

       if (keyCode==RIGHT) 
                 { angle=2*PI/3;
                   vitesse=-50;
                   t=0;
                   yPosOrigineJoueur1=yPosJoueur1;
                   xPosOrigineJoueur1=xPosJoueur1;
                   hitJ1=0;
                 }
      
       if (keyCode==UP) 
                 { angle=PI/2;
                   vitesse=-50;
                   t=0;
                   yPosOrigineJoueur1=yPosJoueur1;
                   xPosOrigineJoueur1=xPosJoueur1;
                   hitJ1=0;
                  }
      
      
      if (keyCode==DOWN) { hitJ1=0;}
    }
  }
}

void keyReleased(){
  
      if (key=='1') {
        hitJ1=0;
        }
        if (key=='a') {
        hitJ2=0;
        }
}

/////////////////////////////////////////////////////////////////////////////
//Action des clics de souris sur les "boutons menus". Reset des paramétres //
/////////////////////////////////////////////////////////////////////////////

void mouseClicked(){
      if (mouseY>391 && mouseY < 615 && mouseX > 650 && mouseX < 1270 && ecranTitre== true)
            { ecranTitre= false;
              reset();
              nbEjectionJoueur1=nbEjectionJoueur2=0;
              }
     if (mouseY>775 && mouseY< 1050 && mouseX > 750 && mouseX <1175 && (nbEjectionJoueur1 > 200 || nbEjectionJoueur2 > 200))
            {
              reset();
              nbEjectionJoueur1=nbEjectionJoueur2=0;
            }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Fonction reset des parametres afin de réafficher les balles a l'ecran, conserver le score, enlever l'ecran titre ou prendre sa revenche //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void reset(){ 
  //////////////////////////////////////////
  //Parametrage des variables du joueur 1 //
  //////////////////////////////////////////
  

  xPosJoueur1 = 100;          //Position en X du joueur.l'origine du repere est le coin haut gauche de la fenetre
  yPosJoueur1 =200;           //Position en Y du joueur.l'origine du repere est le coin haut gauche de la fenetre
  xPosOrigineJoueur1=100;     //Variable de Stockage de la position d'origine du saut
  yPosOrigineJoueur1=200;     //Variable de stockage de la position d'origine du saut
  vitesse = -20;              //vitesse initiale durant les saut. Est incrémenté lorsque l'on recoit un coup.
  gravity = 8;                //influence la vitesse de chute du joueur.
  t=0;                        //variable de temps neccessaire à l'équation de trajectoire
  angle=15 ;                  //angle du saut lors du déplacement de base
  
  //////////////////////////////////////////
  //Parametrage des variables du joueur 2 //
  //////////////////////////////////////////
  
  xPosJoueur2 = 1880;         //Position en X du joueur.l'origine du repere est le coin haut gauche de la fenetre
  yPosJoueur2 =200;           //Position en Y du joueur.l'origine du repere est le coin haut gauche de la fenetre
  xPosOrigineJoueur2=1880;    //Variable de stockage de la position d'origine du saut
  yPosOrigineJoueur2=200;     //Variable de stockage de la position d'oringine du saut
  vitesse1 = 20;              //vitesse initiale durant les saut. Est incrémenté lorsque l'on recoit un coup. son signe oriente la balle vers la gauche
  gravity1 = 8;               //influence la vitesse de chute du joueur.
  t1=0;                       //variable de temps neccessaire à l'équation de trajectoire
  angle1=-15 ;                //angle du saut lors du déplacement de base
  score = 0;
}
