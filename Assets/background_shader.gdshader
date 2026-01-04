shader_type canvas_item;

// Zpřístupní parametry v editoru pro snadnou úpravu
uniform vec2 smer_a_rychlost = vec2(0.1, 0.1); 

void fragment() {
    // UV souřadnice se posouvají v čase
    vec2 pohyb = UV + (smer_a_rychlost * TIME);
    
    // Získá barvu textury na posunuté pozici
    COLOR = texture(TEXTURE, pohyb);
}