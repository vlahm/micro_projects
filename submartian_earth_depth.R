r_mars = 3380000 # m
r_earth = 6365000 # m
m_mars = 6.4171e23 # kg
m_earth = 5.972e24 # kg
m_me = 79.4 # kg
G = 6.674e-11 # m^3 * kg * s^2

F_earth_surface = G * m_earth * m_me / r_earth^2
F_mars_surface = G * m_mars * m_me / r_mars^2

r_mars_earthEquiv = sqrt(G * m_mars * m_me / F_earth_surface)

depth_mars_earthEquiv = r_mars - r_mars_earthEquiv
prop_mars_earthEquiv = depth_mars_earthEquiv / r_mars
