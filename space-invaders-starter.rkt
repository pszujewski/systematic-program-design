;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

;; there is a rocket hit if the rocket is within the x, y of the invader by 10px
(define HIT-RANGE 10)

;; Rate at which new invader appears
(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

;; Invader Image
(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

;; Tank Image
(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))

;; Data Definitions:

(define-struct game (invaders missiles tank tickct))
;; Game is (make-game  (listof Invader) (listof Missile) Tank Natural)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game g)
  (... (fn-for-loinvader (game-invaders g))
       (fn-for-lom (game-missiles g))
       (fn-for-tank (game-tank g))
       (game-tickct g)))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right
(define I4 (make-invader 150 0 10))             ;exactly at top of scene, moving right
(define I5 (make-invader 150 20 10))
(define I6 (make-invader 250 50 -10))
(define I7 (make-invader WIDTH 200 10))
(define I8 (make-invader 0 200 -10))

#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))

;; ListOfInvader is one of:
;;   - empty
;;   - (cons Invader ListOfInvader)
;; interp. a list of invaders
(define LOI0 empty)
(define LOI1 (list I1 I2))
(define LOI2 (list I4 (make-invader 100 0 10) (make-invader 200 350 -10))) ; last invader is moving left
#;
(define (fn-for-loinvader loinvader)
  (cond [(empty? loinvader) (...)]
        [else
         (...(fn-for-invader (first loinvader))
             (fn-for-loinvader (rest loinvader)))]))

;; Template rules used:
;;   - one of: 2 cases
;;   - atomic-distinct: empty
;;   - compound: (cons Invader ListOfInvader)
;;   - reference: (first loinvader) is Invader
;;   - self-reference: (rest loinvader) is ListOfInvader

(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1
(define M4 (make-missile 100 1)) ; top of scene

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))

;; data definition for ListOfMissile
;; ListOfMissle is one of:
;;   - empty
;;   - (cons Missle ListOfMissile)
;; interp. a list of the active missiles in the world
(define LOM0 empty)
(define LOM1 (list M1 M2 M3))
(define LOM2 (list M1 M4 (make-missile 250 400) (make-missile 10 320)))
#;
(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (... (fn-for-missile (first lom))
              (fn-for-lom (rest lom)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic-distinct: empty
;;  - compound: (cons Missle ListOfMissile)
;;  - reference: (first lom) is Missile
;;  - self-reference: (rest lom) is ListOfMissile

(define GSTART (make-game empty empty T0 0))
(define G0 (make-game empty empty T0 5))
(define G1 (make-game empty empty T1 6))
(define G2 (make-game (list I1) (list M1) T1 20))
(define G3 (make-game (list I1 I2) (list M1 M2) T1 16))
(define G8 (make-game (list I1 I2) (list M1 M2) T1 INVADE-RATE))
(define G9 (make-game (list I1 I4) (list M1 M2) T1 16))
(define G10 (make-game (list I3 I4) (list M1 M2) T1 16))

;; World Program

;; =================
;; Functions:

;; Game -> Game
;; start the world with (main GSTART)
;; 
(define (main g)
  (big-bang g                             ; Game
    (on-tick advance-game)                ; Game -> Game
    (to-draw render)                      ; Game -> Image
    (stop-when invaders-won? handle-end)  ; Game -> Boolean 
    (on-key handle-key)))                 ; Game KeyEvent -> Game

;; stop-when handlers
;;
;; ================

;; Game -> Boolean
;; Produce true if one of the invaders has reached the bottom of the screen
;; (define (invaders-won? g) false) ; stub
(check-expect (invaders-won? G2) false)
(check-expect (invaders-won? G3) true)
(check-expect (invaders-won? G9) false)
(check-expect (invaders-won? G10) true)
;; <use template for game to access list of invaders on game>
(define (invaders-won? g)
  (handle-invaders-won? (game-invaders g)))
;; <use template for list of invaders>
(define (handle-invaders-won? loinvader)
  (cond [(empty? loinvader) false]
        [else
         (if (did-invader-win? (first loinvader))
             true
             (handle-invaders-won? (rest loinvader)))]))

;; Invader -> Boolean
;; Produce true if the given invader has reached the bottom of the screen (y > HEIGHT)
;; (define (did-invader-win? invader) false) ; stub
(check-expect (did-invader-win? I1) false)
(check-expect (did-invader-win? I2) true)
(check-expect (did-invader-win? I3) true)
(check-expect (did-invader-win? I4) false)
;; <use template for invader>
(define (did-invader-win? invader)
  (>= (invader-y invader) HEIGHT))

;; Game -> Image
;; Displays a "Game Over" message
(define (handle-end g)
  (place-image (text "Game Over" 48 "blue") 150 200 BACKGROUND)) 

;; on-tick handlers
;;
;; ================

;; Game -> Game
;; produce the next state of the game
;(define (advance-game g) g) ; stub
(check-expect (advance-game G2)
              (make-game (add-invader (game-tickct G2)
                                      (advance-invaders (filter-invaders (game-invaders G2) (game-missiles G2))))
                         (advance-missiles (filter-missiles (game-missiles G2) (game-invaders G2)))
                         (advance-tank (game-tank G2))
                         (handle-tickct (game-tickct G2))))
(check-expect (advance-game G3)
              (make-game (add-invader (game-tickct G3)
                                      (advance-invaders (filter-invaders (game-invaders G3) (game-missiles G3))))
                         (advance-missiles (filter-missiles (game-missiles G3) (game-invaders G3)))
                         (advance-tank (game-tank G3))
                         (handle-tickct (game-tickct G3))))
;; <use template for game>
(define (advance-game g)
  (make-game (add-invader (game-tickct g)
                          (advance-invaders (filter-invaders (game-invaders g) (game-missiles g))))
             (advance-missiles (filter-missiles (game-missiles g) (game-invaders g)))
             (advance-tank (game-tank g))
             (handle-tickct (game-tickct g))))

;; Number -> Number
;; Increase the given game-tickct number by 1 if less than the INVADE-RATE, otherwise reset to 0
;; (define (handle-tickct ct) ct) ; stub
(check-expect (handle-tickct 0) 1) ; start
(check-expect (handle-tickct 20) 21)
(check-expect (handle-tickct INVADE-RATE) 0) ; end -> reset to 0
;; <template according to interval [0, INVADE-RATE]>
(define (handle-tickct ct)
  (if (= ct INVADE-RATE)
      0
      (+ ct 1)))


;; Natural ListOfInvaders -> ListOfInvaders
;; Adds a new invader to the list if 1st argument = INVADE-RATE
;; (define (add-invader ct loinvaders) loinvaders) ; stub
(check-expect (add-invader 5 (list I1 I2))
              (list I1 I2))
(check-expect (add-invader INVADE-RATE (list I1 I2))
              (list (make-invader 150 0 10) I1 I2))
;; <template according to atomic distinct>
(define (add-invader ct loinvaders)
  (if (= ct INVADE-RATE)
      (cons (make-invader 150 0 10) loinvaders)
      loinvaders))

;; ListOfInvaders ListOfMissile -> ListOfInvaders
;; Filter out the Invaders from the list that have been hit by a missile
;(define (filter-invaders loinvaders lom) loinvaders) ; stub
(check-expect (filter-invaders empty empty) empty)
(check-expect (filter-invaders (list (make-invader 250 300 10) (make-invader 150 100 10))
                               (list (make-missile 142 99) (make-missile 2 2)))
              (list (make-invader 250 300 10)))
;; <use template for list of invader with additional paramater of list of missile>
(define (filter-invaders loinvader lom)
  (cond [(empty? loinvader) empty]
        [else
         (if (is-hit? (first loinvader) lom)
             (filter-invaders (rest loinvader) lom)
             (cons (first loinvader)
                   (filter-invaders (rest loinvader) lom)))]))

;; Invader ListOfMissile -> Boolean
;; Produce true if one of the missiles in the list is within the HIT-RANGE of the given Invader
;; (define (is-hit? invader lom) false) ;stub
(check-expect (is-hit? (make-invader 250 140 10) empty) false)
(check-expect (is-hit? (make-invader 150 100 10)
                       (list (make-missile 142 99) (make-missile 2 2))) true)
(check-expect (is-hit? (make-invader 250 140 10)
                       (list (make-missile 142 99) (make-missile 2 2))) false)
(check-expect (is-hit? (make-invader 221 196 10)
                       (list (make-missile 142 99) (make-missile 146 78) (make-missile 220 201))) true)
;; <use template for list of missile, with additional parameter of an invader>
(define (is-hit? invader lom)
  (cond [(empty? lom) false]
        [else
         (if (is-in-hit-range? invader (first lom))
             true
             (is-hit? invader (rest lom)))]))

;; Invader Missile -> Boolean
;; Produce true if the given Invader and Missile have x, y coords. with the HIT-RANGE
;; (define (is-in-hit-range? invader m) false) ; stub
(check-expect (is-in-hit-range? (make-invader 250 140 10) (make-missile 142 99)) false)
(check-expect (is-in-hit-range? (make-invader 221 196 10) (make-missile 220 201)) true)
;; <combine templates for Invader and Missile>
(define (is-in-hit-range? invader m)
  (and (< (abs (- (invader-x invader) (missile-x m))) HIT-RANGE)
       (< (abs (- (invader-y invader) (missile-y m))) HIT-RANGE)))

;; ListOfMissiles ListOfInvaders -> ListOfMissiles
;; Filter out the missiles from the list that have either hit and destroyed an invader, or exited the scene (y = 0)
;; (define (filter-missiles lom loinvaders) lom) ; stub
(check-expect (filter-missiles empty empty) empty)
(check-expect (filter-missiles (list (make-missile 142 99) (make-missile 2 2))
                               (list (make-invader 250 300 10) (make-invader 150 100 10)))
              (list (make-missile 2 2)))
;; <use template for list of missiles>
(define (filter-missiles lom loinvaders)
  (cond [(empty? lom) empty]
        [else
         (if (or (<= (missile-y (first lom)) 0)
                 (has-missile-impact? (first lom) loinvaders))
             (filter-missiles (rest lom) loinvaders)
             (cons (first lom) (filter-missiles (rest lom) loinvaders)))]))

;; Missile ListOfInvaders -> Boolean
;; Produce true if the given Missile has x and y coords. within the HIT-RANGE of one of Invaders in the given list
;; (define (has-missile-impact? m loinvader) false) ; stub
(check-expect (has-missile-impact? (make-missile 142 99) empty) false)
(check-expect (has-missile-impact? (make-missile 142 99)
                                   (list (make-invader 250 300 10) (make-invader 150 100 10))) true)
(check-expect (has-missile-impact? (make-missile 42 99)
                                   (list (make-invader 250 300 10) (make-invader 150 100 10))) false)
;; <use template for list of invader with additional parameter of Missile>
(define (has-missile-impact? m loinvader)
  (cond [(empty? loinvader) false]
        [else
         (if (is-in-hit-range? (first loinvader) m)
             true
             (has-missile-impact? m (rest loinvader)))]))

;; ListOfInvaders -> ListOfInvaders
;; Advance each invader in the list, invaders should advance at 45 degress angles and bounce off the walls of the scene
;(define (advance-invaders loinvaders) loinvaders) ; stub
(check-expect (advance-invaders empty) empty)
(check-expect (advance-invaders (list I1 I5))
              (list (next-invader I1) (next-invader I5)))
(check-expect (advance-invaders (list I1 I6 I4))
              (list (next-invader I1) (next-invader I6) (next-invader I4)))
;; <use template for list of invaders>
(define (advance-invaders loinvader)
  (cond [(empty? loinvader) empty]
        [else
         (cons (next-invader (first loinvader))
               (advance-invaders (rest loinvader)))]))

;; Invader -> Invader
;; Produce the next invader with its x-coord increased by invader-dx, y increases at INVADER-Y-SPEED
;; (define (next-invader invader) invader) ; stub
(check-expect (next-invader I6)
              (make-invader (+ (invader-x I6) (invader-dx I6))
                            (+ (invader-y I6) INVADER-Y-SPEED)
                            (next-dx I6)))
(check-expect (next-invader I7)
              (make-invader (+ (invader-x I7) (invader-dx I7))
                            (+ (invader-y I7) INVADER-Y-SPEED)
                            (next-dx I7)))
(check-expect (next-invader I8)
              (make-invader (+ (invader-x I8) (invader-dx I8))
                            (+ (invader-y I8) INVADER-Y-SPEED)
                            (next-dx I8)))
;; <use template for invader>
(define (next-invader invader)
  (make-invader (+ (invader-x invader) (invader-dx invader))
                (+ (invader-y invader) INVADER-Y-SPEED)
                (next-dx invader)))

;; Invader -> Number
;; Produce the next invader-dx value given the current invader; flip the dx value if invader has reached x = 0 or x = WIDTH
;; (define (next-dx invader) 0) ; stub
(check-expect (next-dx I5) 10)
(check-expect (next-dx I7) -10)
(check-expect (next-dx I8) 10)
;; <use template for invader>
(define (next-dx invader)
  (if (or (>= (+ (invader-x invader) (invader-dx invader)) WIDTH)
          (<= (+ (invader-x invader) (invader-dx invader)) 0))
      (- (invader-dx invader))
      (invader-dx invader)))

;; ListOfMissiles -> ListOfMissiles
;; Advance each Missile in the list by MISSILE-SPEED (10)
;; (define (advance-missiles lom) lom) ; stub
(check-expect (advance-missiles empty) empty)
(check-expect (advance-missiles (list M1 M2))
              (list (move-missile-up M1) (move-missile-up M2)))
;; <use template for ListOfMissile>
(define (advance-missiles lom)
  (cond [(empty? lom) empty]
        [else
         (cons (move-missile-up (first lom))
               (advance-missiles (rest lom)))]))

;; Missile -> Missile
;; Produce a new missile with a missile-y value that is MISSILE-SPEED greater than the given Missile
; (define (move-missile-up m) m) ; stub
(check-expect (move-missile-up M1)
              (make-missile (missile-x M1) (- (missile-y M1) MISSILE-SPEED)))
(check-expect (move-missile-up M2)
              (make-missile (missile-x M2) (- (missile-y M2) MISSILE-SPEED)))
(check-expect (move-missile-up M4)
              (make-missile (missile-x M4) (- (missile-y M4) MISSILE-SPEED)))
;; <use template for missile>
(define (move-missile-up m)
  (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED)))

;; Tank -> Tank
;; Advance the given Tank by Tank-Speed on the x-axis
;; (define (advance-tank t) t) ; stub
(check-expect (advance-tank T0)
              (make-tank (+ TANK-SPEED (tank-x T0)) (tank-dir T0)))
(check-expect (advance-tank T1)
              (make-tank (+ TANK-SPEED (tank-x T1)) (tank-dir T1)))
(check-expect (advance-tank T2)
              (make-tank (- (tank-x T2) TANK-SPEED) (tank-dir T2)))
;; <use template for tank, added tempalte for small enumeration>
(define (advance-tank t)
  (cond [(= (tank-dir t) 1) (make-tank (move-tank-right (tank-x t)) (tank-dir t))]
        [else
         (make-tank (move-tank-left (tank-x t)) (tank-dir t))]))

;; Number -> Number
;; Produce the new x-coord for the tank moving to the right given the current x-coord
;; (define (move-tank-right x) 0) ; stub
(check-expect (move-tank-right 10) (+ 10 TANK-SPEED))
(check-expect (move-tank-right 299) 299)
(check-expect (move-tank-right 300) 300)
(check-expect (move-tank-right 202) (+ 202 TANK-SPEED))
;; <templated according to atomic non-distinct>
(define (move-tank-right x)
  (if (> (+ x TANK-SPEED) WIDTH) x (+ x TANK-SPEED)))

;; Number -> Number
;; Produce the new x-coord of the tank moving to the left given the current x-coord
;; (define (move-tank-left x) 0) ; stub
(check-expect (move-tank-left 20) (- 20 TANK-SPEED))
(check-expect (move-tank-left 300) (- 300 TANK-SPEED))
(check-expect (move-tank-left 0) 0)
(check-expect (move-tank-left 1) 1)
;; <templated according to atomic non-distinct>
(define (move-tank-left x)
  (if (> 0 (- x TANK-SPEED)) x (- x TANK-SPEED)))

;; on-key handlers
;;
;; ===============

;; Game -> Game
;; handle the given key event, pass to correct function
(check-expect (handle-key G1 "up") G1)
(check-expect (handle-key G1 "right") (update-tank-direction G1 1))
(check-expect (handle-key G1 "left") (update-tank-direction G1 -1))
(check-expect (handle-key G1 " ") (fire-one-missile G1))
;; (define (handle-key g kevt) g) ; stub
;; <templated according to enumeration>
(define (handle-key g kevt)
  (cond [(string=? kevt "right") (update-tank-direction g 1)]
        [(string=? kevt "left") (update-tank-direction g -1)]
        [(string=? kevt " ") (fire-one-missile g)]
        [else g]))

;; Game -> Game
;; Move the tank left or right by TANK-SPEED given the current state of the Game
;(define (update-tank-direction g dir) g) ; stub
(check-expect (update-tank-direction G0 1)
              (make-game (game-invaders G0)
                         (game-missiles G0)
                         (make-tank (tank-x (game-tank G0)) 1)
                         (game-tickct G0)))
(check-expect (update-tank-direction G2 -1)
              (make-game (game-invaders G2)
                         (game-missiles G2)
                         (make-tank (tank-x (game-tank G2)) -1)
                         (game-tickct G2)))
;; <use template for game>
(define (update-tank-direction g dir)
  (make-game (game-invaders g)
             (game-missiles g)
             (make-tank (tank-x (game-tank g)) dir)
             (game-tickct g)))

;; Game -> Game
;; Fire one missile when spacebar is pressed
(check-expect (fire-one-missile G2)
              (make-game (game-invaders G2)
                         (cons (make-missile (tank-x (game-tank G2)) (- HEIGHT TANK-HEIGHT/2))
                               (game-missiles G2))
                         (game-tank G2)
                         (game-tickct G2)))
(check-expect (fire-one-missile G3)
              (make-game (game-invaders G3)
                         (cons (make-missile (tank-x (game-tank G3)) (- HEIGHT TANK-HEIGHT/2))
                               (game-missiles G3))
                         (game-tank G3)
                         (game-tickct G3)))
;(define (fire-one-missile g) g) ; stub
;; <use template for game>
(define (fire-one-missile g)
  (make-game (game-invaders g)
             (cons (make-missile (tank-x (game-tank g)) (- HEIGHT TANK-HEIGHT/2)) (game-missiles g))
             (game-tank g)
             (game-tickct g)))

;; to-draw handlers (render)
;;
;; ========================

;; Tank -> Image
;; Render the current state of the Game's Tank given only the Tank
;(define (render-tank t) BACKGROUND)
(check-expect (render-tank T0)
              (place-image TANK (tank-x T0) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
(check-expect (render-tank T2)
              (place-image TANK (tank-x T2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
;; <use template for tank>
(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;; ListOfInvaders Image -> Image
;; Render the current state of the Game's ListOfInvaders
;; (define (render-invaders g image) image) ; stub
(check-expect (render-invaders empty BACKGROUND) BACKGROUND)
(check-expect (render-invaders (list I1) BACKGROUND)
              (place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND))
(check-expect (render-invaders (list I1 I2) BACKGROUND)
              (place-image INVADER (invader-x I1) (invader-y I1)
                           (place-image INVADER (invader-x I2) (invader-y I2) BACKGROUND)))
;; <use template for ListOfInvaders>
(define (render-invaders loinvader image)
  (cond [(empty? loinvader) image]
        [else
         (render-one-invader (first loinvader)
                             (render-invaders (rest loinvader) image))]))

;; Invader Image -> Image
;; Render a single invader given the invader and scene
;; (define (render-one-invader invader image) image)  ; stub
(check-expect (render-one-invader I1 BACKGROUND)
              (place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND))
(check-expect (render-one-invader I3 BACKGROUND)
              (place-image INVADER (invader-x I3) (invader-y I3) BACKGROUND))
;; <use template for invader>
(define (render-one-invader invader image)
  (place-image INVADER (invader-x invader) (invader-y invader) image))

;; ListOfMissiles Image -> Image
;; Produce the Current state of the Game's missles given the ListOfMissiles
;; (define (render-missiles lom image) image) ; stub
;(define LOM1 (list M1 M2 M3))
;(define LOM2 (list M1 M4 (make-missile 250 400) (make-missile 10 320)))
(check-expect (render-missiles empty BACKGROUND) BACKGROUND)
(check-expect (render-missiles (list M4) BACKGROUND)
              (place-image MISSILE (missile-x M4) (missile-y M4) BACKGROUND))
(check-expect (render-missiles (list M1 M2 M3) BACKGROUND)
              (place-image MISSILE (missile-x M1) (missile-y M1)
                           (place-image MISSILE (missile-x M2) (missile-y M2)
                                        (place-image MISSILE (missile-x M3) (missile-y M3) BACKGROUND))))
;; <use template for ListOfMissiles>
(define (render-missiles lom image)
  (cond [(empty? lom) image]
        [else
         (render-one-missile (first lom)
                             (render-missiles (rest lom) image))]))

;; Missile Image -> Image
;; Produce the image of one Missile given the Missile
;; (define (render-one-missile m image) image) ; stub
(check-expect (render-one-missile M1 BACKGROUND)
              (place-image MISSILE (missile-x M1) (missile-y M1) BACKGROUND))
(check-expect (render-one-missile M4 BACKGROUND)
              (place-image MISSILE (missile-x M4) (missile-y M4) BACKGROUND))
;; <use template for Missile>
(define (render-one-missile m image)
  (place-image MISSILE (missile-x m) (missile-y m) image))

;; Game -> Image
;; render the current state of the given Game 
;; (define (render g) BACKGROUND) ; stub
(check-expect (render G0)
              (render-missiles (game-missiles G0)
                               (render-invaders (game-invaders G0)
                                                (render-tank (game-tank G0)))))
(check-expect (render G3)
              (render-missiles (game-missiles G3)
                               (render-invaders (game-invaders G3)
                                                (render-tank (game-tank G3)))))
;; <use template for game>
(define (render g)
  (render-missiles (game-missiles g)
                   (render-invaders (game-invaders g)
                                    (render-tank (game-tank g)))))


