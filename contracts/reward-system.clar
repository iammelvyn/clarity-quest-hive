;; RewardSystem Contract
;; Manages rewards and experience points

;; Constants
(define-fungible-token quest-points)

(define-constant levels
  (list
    { xp: u0, name: "Novice" }
    { xp: u100, name: "Apprentice" }
    { xp: u500, name: "Adept" }
    { xp: u2000, name: "Master" }))

;; Data Maps
(define-map user-stats
  { user: principal }
  { xp: uint,
    level: uint,
    total-completions: uint })

;; Public Functions      
(define-public (award-completion (user principal) (difficulty uint))
  (let ((xp-gain (* difficulty u10))
        (current-stats (default-to
          { xp: u0, level: u0, total-completions: u0 }
          (map-get? user-stats { user: user }))))
    (map-set user-stats
      { user: user }
      { xp: (+ (get xp current-stats) xp-gain),
        level: (calculate-level (+ (get xp current-stats) xp-gain)),
        total-completions: (+ (get total-completions current-stats) u1) })
    (ft-mint? quest-points xp-gain user)
    (ok true)))

(define-read-only (get-user-stats (user principal))
  (ok (map-get? user-stats { user: user })))
