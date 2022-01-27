-- Copyright © 2008-2022 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

-- source: http://vrk.fi/sv/namntjanst, specifically:
-- http://verkkopalvelu.vrk.fi/Nimipalvelu/default.asp?L=2

local CultureName = require './common'

local male = {
	"Juhani",
	"Olavi",
	"Antero",
	"Tapani",
	"Johannes",
	"Tapio",
	"Mikael",
	"Kalevi",
	"Matti",
	"Pekka",
	"Petteri",
	"Ilmari",
	"Sakari",
	"Matias",
	"Antti",
	"Juha",
	"Heikki",
	"Kristian",
	"Timo",
	"Kari",
	"Mikko",
	"Markus",
	"Jukka",
	"Jari",
	"Kalervo",
	"Markku",
	"Aleksi",
	"Jaakko",
	"Petri",
	"Mika",
	"Oskari",
	"Erkki",
	"Lauri",
	"Veikko",
	"Henrik",
	"Hannu",
	"Seppo",
	"Ville",
	"Ensio",
	"Pentti",
	"Ari",
	"Janne",
	"Marko",
	"Valtteri",
	"Tuomas",
	"Sami",
	"Juho",
	"Eero",
	"Martti",
	"Erik",
	"Jorma",
	"Jani",
	"Elias",
	"Samuli",
	"Jussi",
	"Harri",
	"Risto",
	"Eemeli",
	"Raimo",
	"Teemu",
	"Onni",
	"Pertti",
	"Veli",
	"Jarmo",
	"Esa",
	"Eino",
	"Esko",
	"Pasi",
	"Jouni",
	"Arto",
	"Samuel",
	"Jouko",
	"Reijo",
	"Vesa",
	"Olli",
	"Niko",
	"Paavo",
	"Kalle",
	"Joonas",
	"Toni",
	"Toivo",
	"Armas",
	"Johan",
	"Viljami",
	"Santeri",
	"Kimmo",
	"Tomi",
	"Emil",
	"Leo",
	"Henri",
	"Joni",
	"Tero",
	"Tommi",
	"Väinö",
	"Pauli",
	"Ilkka",
	"Eetu",
	"Oliver",
	"Uolevi",
	"Otto",
	"Daniel",
	"Ilari",
	"Sebastian",
	"Tuomo",
	"Aulis",
	"Alexander",
	"Jarkko",
	"Jalmari",
	"Anton",
	"Aleksanteri",
	"Jesse",
	"Eemil",
	"Joona",
	"Simo",
	"Akseli",
	"Vilho",
	"Allan",
	"Arttu",
	"Keijo",
	"Einari",
	"Jere",
	"Kullervo",
	"Juuso",
	"Lasse",
	"Kauko",
	"Reino",
	"Christian",
	"Jyrki",
	"Mauri",
	"Kaarlo",
	"Joel",
	"Niilo",
	"Julius",
	"Benjamin",
	"Niklas",
	"Jan",
	"Aukusti",
	"Leevi",
	"Aarne",
	"Kai",
	"Yrjö",
	"Aki",
	"Juhana",
	"Artturi",
	"Miika",
	"Tauno",
	"Riku",
	"Elmeri",
	"Karl",
	"Teuvo",
	"Rauno",
	"Peter",
	"Rasmus",
	"Jarno",
	"Hermanni",
	"Veeti",
	"Topias",
	"Eerik",
	"Aaro",
	"Ossi",
	"Vilhelm",
	"Arvo",
	"Joonatan",
	"Osmo",
	"Viljo",
	"Aatos",
	"Valdemar",
	"Veijo",
	"Taisto",
	"Rainer",
	"Ismo",
	"Robert",
	"Anssi",
	"Patrik",
	"Aimo",
	"Henry",
	"Anders",
	"Roope",
	"Atte",
	"Asko",
	"Eelis",
	"Henrikki",
	"Taneli",
	"Miro",
	"Edvard",
	"Aapo",
	"Samu",
	"Aaron",
	"Lassi",
	"Ahti",
	"Mauno",
	"Oiva",
	"Iisakki",
	"Oskar",
	"Kim",
	"Tuukka",
	"Kasper",
	"Verneri",
	"Kustaa",
	"Lars",
	"Aarre"
}

local female = {
	"Maria",
	"Helena",
	"Anneli",
	"Johanna",
	"Kaarina",
	"Marjatta",
	"Hannele",
	"Kristiina",
	"Liisa",
	"Emilia",
	"Elina",
	"Annikki",
	"Tuulikki",
	"Maarit",
	"Susanna",
	"Sofia",
	"Leena",
	"Katariina",
	"Anna",
	"Marja",
	"Sinikka",
	"Inkeri",
	"Riitta",
	"Kyllikki",
	"Aino",
	"Tuula",
	"Anne",
	"Päivi",
	"Orvokki",
	"Ritva",
	"Tellervo",
	"Maija",
	"Pirjo",
	"Karoliina",
	"Pauliina",
	"Minna",
	"Sari",
	"Irmeli",
	"Eeva",
	"Tiina",
	"Laura",
	"Elisabet",
	"Pirkko",
	"Marika",
	"Tarja",
	"Eveliina",
	"Anja",
	"Satu",
	"Seija",
	"Eila",
	"Mari",
	"Hanna",
	"Marita",
	"Heidi",
	"Raija",
	"Sirpa",
	"Annika",
	"Irene",
	"Sisko",
	"Jaana",
	"Anita",
	"Sanna",
	"Eija",
	"Kirsi",
	"Marianne",
	"Ilona",
	"Merja",
	"Julia",
	"Katriina",
	"Ulla",
	"Arja",
	"Sirkka",
	"Amanda",
	"Terttu",
	"Paula",
	"Kaisa",
	"Marketta",
	"Anni",
	"Marjaana",
	"Tuulia",
	"Elisabeth",
	"Elisa",
	"Matilda",
	"Linnea",
	"Jenni",
	"Helmi",
	"Katja",
	"Hilkka",
	"Olivia",
	"Mirjami",
	"Kirsti",
	"Heli",
	"Iida",
	"Raili",
	"Aurora",
	"Mirja",
	"Nina",
	"Emma",
	"Katri",
	"Anniina",
	"Maaria",
	"Birgitta",
	"Kaija",
	"Sara",
	"Suvi",
	"Ida",
	"Marjut",
	"Riikka",
	"Anu",
	"Saara",
	"Tuija",
	"Ella",
	"Aleksandra",
	"Kerttu",
	"Lea",
	"Irma",
	"Aila",
	"Niina",
	"Pia",
	"Irja",
	"Alexandra",
	"Leila",
	"Kristina",
	"Marja",
	"Marjo",
	"Noora",
	"Tanja",
	"Jenna",
	"Margareta",
	"Aulikki",
	"Henna",
	"Mirjam",
	"Kati",
	"Veera",
	"Hellevi",
	"Marja",
	"Lotta",
	"Anna",
	"Maritta",
	"Outi",
	"Elsa",
	"Elli",
	"Taina",
	"Ellen",
	"Milla",
	"Mervi",
	"Päivikki",
	"Emmi",
	"Helinä",
	"Miia",
	"Virpi",
	"Aune",
	"Alina",
	"Erika",
	"Margit",
	"Siiri",
	"Jonna",
	"Sini",
	"Tiia",
	"Vilhelmiina",
	"Sonja",
	"Venla",
	"Aada",
	"Maire",
	"Sanni",
	"Terhi",
	"Jasmin",
	"Josefiina",
	"Mia",
	"Vilma",
	"Mira",
	"Linda",
	"Esteri",
	"Oona",
	"Martta",
	"Eliisa",
	"Teija",
	"Roosa",
	"Airi",
	"Nea",
	"Hillevi",
	"Alisa",
	"Carita",
	"Essi",
	"Aili",
	"Piia",
	"Lilja",
	"Christina",
	"Taru",
	"Viivi",
	"Helvi",
	"Marjukka",
	"Vuokko",
	"Krista",
	"Petra",
	"Iiris",
	"Annukka",
	"Tuuli",
	"Juulia",
	"Iina",
	"Marie"
}

local surname = {
	"Korhonen",
	"Virtanen",
	"Mäkinen",
	"Nieminen",
	"Mäkelä",
	"Hämäläinen",
	"Laine",
	"Heikkinen",
	"Koskinen",
	"Järvinen",
	"Lehtonen",
	"Lehtinen",
	"Saarinen",
	"Salminen",
	"Heinonen",
	"Niemi",
	"Heikkilä",
	"Kinnunen",
	"Salonen",
	"Turunen",
	"Salo",
	"Laitinen",
	"Tuominen",
	"Rantanen",
	"Karjalainen",
	"Jokinen",
	"Mattila",
	"Savolainen",
	"Lahtinen",
	"Ahonen",
	"Ojala",
	"Leppänen",
	"Hiltunen",
	"Väisänen",
	"Leinonen",
	"Miettinen",
	"Kallio",
	"Pitkänen",
	"Aaltonen",
	"Manninen",
	"Hakala",
	"Anttila",
	"Koivisto",
	"Laaksonen",
	"Räsänen",
	"Hirvonen",
	"Lehto",
	"Laakso",
	"Toivonen",
	"Mustonen",
	"Rantala",
	"Aalto",
	"Nurmi",
	"Peltonen",
	"Niemelä",
	"Moilanen",
	"Seppälä",
	"Hänninen",
	"Pulkkinen",
	"Lappalainen",
	"Partanen",
	"Kettunen",
	"Saari",
	"Kauppinen",
	"Kemppainen",
	"Seppänen",
	"Lahti",
	"Koskela",
	"Salmi",
	"Ahola",
	"Huttunen",
	"Suominen",
	"Ikonen",
	"Aho",
	"Kärkkäinen",
	"Pesonen",
	"Halonen",
	"Mikkonen",
	"Johansson",
	"Nyman",
	"Koponen",
	"Peltola",
	"Oksanen",
	"Lindholm",
	"Vainio",
	"Heiskanen",
	"Niskanen",
	"Mikkola",
	"Koski",
	"Immonen",
	"Honkanen",
	"Nurminen",
	"Vuorinen",
	"Harju",
	"Kokkonen",
	"Rissanen",
	"Määttä",
	"Karppinen",
	"Mäki",
	"Laukkanen",
	"Rajala",
	"Juntunen",
	"Heino",
	"Rautiainen",
	"Jääskeläinen",
	"Parviainen",
	"Keränen",
	"Kangas",
	"Hartikainen",
	"Paananen",
	"Leino",
	"Karlsson",
	"Mäenpää",
	"Lindström",
	"Ruotsalainen",
	"Martikainen",
	"Hakkarainen",
	"Hyvärinen",
	"Uusitalo",
	"Laurila",
	"Toivanen",
	"Kokko",
	"Tikkanen",
	"Viitanen",
	"Nevalainen",
	"Leskinen",
	"Salmela",
	"Nykänen",
	"Makkonen",
	"Häkkinen",
	"Holopainen",
	"Kuusisto",
	"Tamminen",
	"Eriksson",
	"Andersson",
	"Hietala",
	"Härkönen",
	"Korpela",
	"Ranta",
	"Kukkonen",
	"Hyvönen",
	"Karvonen",
	"Jaakkola",
	"Pasanen",
	"Jokela",
	"Tiainen",
	"Karhu",
	"Väänänen",
	"Kosonen",
	"Saarela",
	"Sillanpää",
	"Malinen",
	"Rautio",
	"Kujala",
	"Virta",
	"Lindroos",
	"Timonen",
	"Autio",
	"Lindqvist",
	"Valtonen",
	"Kivelä",
	"Hokkanen",
	"Kolehmainen",
	"Lampinen",
	"Räisänen",
	"Jussila",
	"Rinne",
	"Tolonen",
	"Nissinen",
	"Nousiainen",
	"Huhtala",
	"Vartiainen",
	"Eskelinen",
	"Laakkonen",
	"Koivula",
	"Asikainen",
	"Koistinen",
	"Lepistö",
	"Kuusela",
	"Lindberg",
	"Liimatainen",
	"Pelkonen",
	"Luoma",
	"Tolvanen",
	"Hautala",
	"Kyllönen",
	"Kulmala",
	"Tuovinen",
	"Koivunen",
	"Pietilä",
	"Penttinen",
	"Helenius",
	"Viljanen",
	"Pennanen",
	"Voutilainen",
	"Hietanen",
	"Hyttinen",
	"Suhonen",
	"Luukkonen",
	"Huotari",
	"Riikonen"
}


local Finish = CultureName.New(
{
	male = male,
	female = female,
	surname = surname,
	name = "Finnish",
	code = "fi",
	replace = {
		["å"] = "a", ["Å"] = "A",
		["ä"] = "a", ["Ä"] = "A",
		["ö"] = "o", ["Ö"] = "O",
	}
})

return Finish
