open import Data.List
open import Data.Nat using (ℕ; zero; suc)
open import Data.Product 
open import Data.Bool
open import Algebra
open import Level using (Level)


module test where
   
    variable
      a b c ℓ : Level
      A : Set a 
      B : Set b
      C : Set c
      m n : ℕ

-- Vector representation
      
    module Vector where
        -- Inductive definition of a vector
        data Vector (A : Set a) : (n : ℕ) → Set a where
          [] : Vector A zero
          _::_ :  A → Vector A n → Vector A (suc n)

        infixr 5 _::_

        vecLength : Vector A n -> ℕ 
        vecLength {n = n} v = n
        
        -- Matrices are defined as vector of vectors 
        Matrix : (A : Set a) (m n : ℕ) → Set a
        Matrix A m n = Vector (Vector A n) m

        matLength : Matrix A m n -> ℕ × ℕ 
        matLength {m = m} {n = n} mat  = m , n

        -- Some examples
        v1 : Vector ℕ 4
        v1 = 1 :: 3 :: 4 :: 5 :: []

        m1 : Matrix ℕ 2 2 
        m1 =  (1 :: 2 :: []) :: (1 :: 2 :: []) :: []  

        mat1 = Matrix Bool 2 2
        
        -- zip for vectors
        zipV : (A → B → C) → (Vector A n → Vector B n → Vector C n)
        zipV f [] [] = []
        zipV f (x :: xs) (y :: ys) = f x y :: zipV f xs ys

        -- map for vectors
        mapV : (A → B) → Vector A n → Vector B n
        mapV f [] = []
        mapV f (x :: v) = f x :: mapV f v

        replicateV : A → Vector A n
        replicateV {n = zero}  x = []
        replicateV {n = suc n} x = x :: replicateV x

        -- Dependent foldr
        foldrV : (B : ℕ → Set b) → (∀ {n} → A → B n → B (suc n)) → B zero → Vector A n → B n
        foldrV B _⊕_ e [] = e
        foldrV B _⊕_ e (x :: xs) = x ⊕ foldrV B _⊕_ e xs

        sumV : Vector ℕ n → ℕ
        sumV = foldrV _⊕_ 0 _ 

        zeroVec : Vector ℕ n
        zeroVec = replicateV 0   

-- Operations

    module Operations (R : Ring c ℓ) where
        open Ring R   
        open Vector             

        infixr 6 _+v_
        infixr 7 _*vₛ_
        infixr 7 _*mₛ_


        -- Vector addition
        _+v_ : Vector Carrier n → Vector Carrier n  → Vector Carrier n 
        _+v_ = zipV _+_  

        -- Scale vector 
        _*vₛ_ : Carrier → Vector Carrier n → Vector Carrier n 
        c *vₛ v = mapV (c *_) v

        -- Dot product
       -- _•_ : Vector Carrier n → Vector Carrier n
       -- _•_ = 

        -- Scale matrix 
        _*mₛ_ : Carrier → Matrix Carrier m n → Matrix Carrier m n
        c *mₛ [] = []
        c *mₛ (v :: vs) = c *vₛ v :: c *mₛ vs
      
       
