;; QuestCore Contract
;; Handles quest management and tracking

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-invalid-quest (err u101))
(define-constant err-already-completed (err u102))

;; Data Types
(define-map quests
  { owner: principal, quest-id: uint }
  { name: (string-ascii 50),
    description: (string-ascii 200),
    difficulty: uint,
    active: bool })

(define-map daily-completions
  { owner: principal, quest-id: uint, day: uint }
  { completed: bool })

;; State Variables  
(define-data-var quest-counter uint u0)

;; Public Functions
(define-public (create-quest (name (string-ascii 50)) (description (string-ascii 200)) (difficulty uint))
  (let ((new-id (+ (var-get quest-counter) u1)))
    (map-insert quests
      { owner: tx-sender, quest-id: new-id }
      { name: name,
        description: description,
        difficulty: difficulty,
        active: true })
    (var-set quest-counter new-id)
    (ok new-id)))

(define-public (complete-daily-quest (quest-id uint))
  (let ((current-day (/ block-height u144)))
    (match (map-get? daily-completions { owner: tx-sender, quest-id: quest-id, day: current-day })
      completion (err err-already-completed)
      (begin
        (map-insert daily-completions
          { owner: tx-sender, quest-id: quest-id, day: current-day }
          { completed: true })
        (ok true)))))
