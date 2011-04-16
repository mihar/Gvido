#rake db:setup to set this baby up

u = User.new(:first_name => "Tomaž", :last_name => "Pačnik", :email => "tomaz.pacnik@gvido.si", :password => "roland2000", :password_confirmation => "roland2000", :admin => true)
u.save

u = User.new(:first_name => "Ljubomir", :last_name => "Marković", :email => "ljm@disru.pt", :password => "ljmljm", :password_confirmation => "ljmljm", :admin => true)
u.save

u = User.new(:first_name => "Miha", :last_name => "Rebernik", :email => "mre@disru.pt", :password => "mremre", :password_confirmation => "mremre", :admin => true)
u.save

BillingOption.create([
  {:short_description => 'Po pošti', :description => 'Učenec želi prejemati položnice na svoj hišni naslov'},
  {:short_description => 'Po emailu', :description => 'Učenec želi prejemati položnice na email'},
  {:short_description => 'Preko mentorja', :description => 'Učenec bo položnico prejel preko mentorja'}
])

Status.create([
  {:short_description => 'V dodajanju', :description => 'Učenec še ni vpisan in potrebno mu je poslati ponudbo.'},
  {:short_description => 'V čakanju', :description => 'Učenec se namerava vpisati vendar je potrebno počakati na potrdilo o vpisu'},
  {:short_description => 'Vpisan', :description => 'Učenec je redno vpisan'},
  {:short_description => 'Izpisan', :description => 'Učenec je izpisan'}
])

PostOffice.create([
  {:id => 1000, :name => 'Ljubljana'}, 
  {:id => 1210, :name => 'Ljubljana - Šentvid'}, 
  {:id => 1211, :name => 'Ljubljana - Šmartno'}, 
  {:id => 1215, :name => 'Medvode'}, 
  {:id => 1216, :name => 'Smlednik'}, 
  {:id => 1217, :name => 'Vodice'}, 
  {:id => 1218, :name => 'Komenda'}, 
  {:id => 1219, :name => 'Laze v Tuhinju'}, 
  {:id => 1221, :name => 'Motnik'}, 
  {:id => 1222, :name => 'Trojane'}, 
  {:id => 1223, :name => 'Blagovica'}, 
  {:id => 1225, :name => 'Lukovica'}, 
  {:id => 1230, :name => 'Domžale'}, 
  {:id => 1231, :name => 'Ljubljana - Črnuče'}, 
  {:id => 1233, :name => 'Dob'}, 
  {:id => 1234, :name => 'Mengeš'}, 
  {:id => 1235, :name => 'Radomlje'}, 
  {:id => 1236, :name => 'Trzin'}, 
  {:id => 1241, :name => 'Kamnik'}, 
  {:id => 1242, :name => 'Stahovica'}, 
  {:id => 1251, :name => 'Moravče'}, 
  {:id => 1252, :name => 'Vače'}, 
  {:id => 1260, :name => 'Ljubljana - Polje'}, 
  {:id => 1261, :name => 'Ljubljana - Dobrunje'}, 
  {:id => 1262, :name => 'Dol pri Ljubljani'}, 
  {:id => 1270, :name => 'Litija'}, 
  {:id => 1272, :name => 'Polšnik'}, 
  {:id => 1273, :name => 'Dole pri Litiji'}, 
  {:id => 1274, :name => 'Gabrovka'}, 
  {:id => 1275, :name => 'Šmartno pri Litiji'}, 
  {:id => 1276, :name => 'Primskovo '}, 
  {:id => 1281, :name => 'Kresnice'}, 
  {:id => 1282, :name => 'Sava'}, 
  {:id => 1290, :name => 'Grosuplje'}, 
  {:id => 1291, :name => 'Škofljica'}, 
  {:id => 1292, :name => 'Ig'}, 
  {:id => 1293, :name => 'Šmarje-Sap'}, 
  {:id => 1294, :name => 'Višnja Gora'}, 
  {:id => 1295, :name => 'Ivančna Gorica'}, 
  {:id => 1296, :name => 'Šentvid pri Stični'}, 
  {:id => 1301, :name => 'Krka'}, 
  {:id => 1303, :name => 'Zagradec'}, 
  {:id => 1310, :name => 'Ribnica'}, 
  {:id => 1311, :name => 'Turjak'}, 
  {:id => 1312, :name => 'Videm-Dobrepolje'}, 
  {:id => 1313, :name => 'Struge'}, 
  {:id => 1314, :name => 'Rob'}, 
  {:id => 1315, :name => 'Velike Lašče'}, 
  {:id => 1316, :name => 'Ortnek'}, 
  {:id => 1317, :name => 'Sodražica'}, 
  {:id => 1318, :name => 'Loški Potok'}, 
  {:id => 1319, :name => 'Draga'}, 
  {:id => 1330, :name => 'Kočevje'}, 
  {:id => 1331, :name => 'Dolenja vas'}, 
  {:id => 1332, :name => 'Stara Cerkev'}, 
  {:id => 1336, :name => 'Vas'}, 
  {:id => 1337, :name => 'Osilnica'}, 
  {:id => 1338, :name => 'Kočevska Reka'}, 
  {:id => 1351, :name => 'Brezovica pri Ljubljani'}, 
  {:id => 1352, :name => 'Preserje'}, 
  {:id => 1353, :name => 'Borovnica'}, 
  {:id => 1354, :name => 'Horjul'}, 
  {:id => 1355, :name => 'Polhov Gradec'}, 
  {:id => 1356, :name => 'Dobrova'}, 
  {:id => 1357, :name => 'Notranje Gorice'}, 
  {:id => 1358, :name => 'Log pri Brezovici'}, 
  {:id => 1360, :name => 'Vrhnika'}, 
  {:id => 1370, :name => 'Logatec'}, 
  {:id => 1371, :name => 'Logatec'}, 
  {:id => 1372, :name => 'Hotedršica'}, 
  {:id => 1373, :name => 'Rovte'}, 
  {:id => 1380, :name => 'Cerknica'}, 
  {:id => 1381, :name => 'Rakek'}, 
  {:id => 1382, :name => 'Begunje pri Cerknici'}, 
  {:id => 1384, :name => 'Grahovo'}, 
  {:id => 1385, :name => 'Nova vas'}, 
  {:id => 1386, :name => 'Stari trg pri Ložu'}, 
  {:id => 1410, :name => 'Zagorje ob Savi'}, 
  {:id => 1411, :name => 'Izlake'}, 
  {:id => 1412, :name => 'Kisovec'}, 
  {:id => 1413, :name => 'Čemšenik'}, 
  {:id => 1414, :name => 'Podkum'}, 
  {:id => 1420, :name => 'Trbovlje'}, 
  {:id => 1423, :name => 'Dobovec'}, 
  {:id => 1430, :name => 'Hrastnik'}, 
  {:id => 1431, :name => 'Dol pri Hrastniku'}, 
  {:id => 1432, :name => 'Zidani Most'}, 
  {:id => 1433, :name => 'Radeče'}, 
  {:id => 1434, :name => 'Loka pri Zidanem Mostu'}, 
  {:id => 2000, :name => 'Maribor'}, 
  {:id => 2201, :name => 'Zgornja Kungota'}, 
  {:id => 2204, :name => 'Miklavž na Dravskem polju'}, 
  {:id => 2205, :name => 'Starše'}, 
  {:id => 2206, :name => 'Marjeta na Dravskem polju'}, 
  {:id => 2208, :name => 'Pohorje'}, 
  {:id => 2211, :name => 'Pesnica pri Mariboru'}, 
  {:id => 2212, :name => 'Šentilj v Slovenskih goricah'}, 
  {:id => 2213, :name => 'Zgornja Velka'}, 
  {:id => 2214, :name => 'Sladki Vrh'}, 
  {:id => 2215, :name => 'Ceršak'}, 
  {:id => 2221, :name => 'Jarenina'}, 
  {:id => 2222, :name => 'Jakobski Dol'}, 
  {:id => 2223, :name => 'Jurovski Dol'}, 
  {:id => 2229, :name => 'Malečnik'}, 
  {:id => 2230, :name => 'Lenart v Slovenskih goricah'}, 
  {:id => 2231, :name => 'Pernica'}, 
  {:id => 2232, :name => 'Voličina'}, 
  {:id => 2233, :name => 'Sv. Ana v Slovenskih goricah'}, 
  {:id => 2234, :name => 'Benedikt'}, 
  {:id => 2235, :name => 'Sv. Trojica v Slovenskih goricah'}, 
  {:id => 2236, :name => 'Cerkvenjak'}, 
  {:id => 2241, :name => 'Spodnji Duplek'}, 
  {:id => 2242, :name => 'Zgornja Korena'}, 
  {:id => 2250, :name => 'Ptuj'}, 
  {:id => 2252, :name => 'Dornava'}, 
  {:id => 2253, :name => 'Destrnik'}, 
  {:id => 2254, :name => 'Trnovska vas'}, 
  {:id => 2255, :name => 'Vitomarci'}, 
  {:id => 2256, :name => 'Juršinci'}, 
  {:id => 2257, :name => 'Polenšak'}, 
  {:id => 2258, :name => 'Sveti Tomaž'}, 
  {:id => 2259, :name => 'Ivanjkovci'}, 
  {:id => 2270, :name => 'Ormož'}, 
  {:id => 2272, :name => 'Gorišnica'}, 
  {:id => 2273, :name => 'Podgorci'}, 
  {:id => 2274, :name => 'Velika Nedelja'}, 
  {:id => 2275, :name => 'Miklavž pri Ormožu'}, 
  {:id => 2276, :name => 'Kog'}, 
  {:id => 2277, :name => 'Središče ob Dravi'}, 
  {:id => 2281, :name => 'Markovci'}, 
  {:id => 2282, :name => 'Cirkulane'}, 
  {:id => 2283, :name => 'Zavrč'}, 
  {:id => 2284, :name => 'Videm pri Ptuju'}, 
  {:id => 2285, :name => 'Zgornji Leskovec'}, 
  {:id => 2286, :name => 'Podlehnik'}, 
  {:id => 2287, :name => 'Žetale'}, 
  {:id => 2288, :name => 'Hajdina'}, 
  {:id => 2289, :name => 'Stoperce'}, 
  {:id => 2310, :name => 'Slovenska Bistrica'}, 
  {:id => 2311, :name => 'Hoče'}, 
  {:id => 2312, :name => 'Orehova vas'}, 
  {:id => 2313, :name => 'Fram'}, 
  {:id => 2314, :name => 'Zgornja Polskava'}, 
  {:id => 2315, :name => 'Šmartno na Pohorju'}, 
  {:id => 2316, :name => 'Zgornja Ložnica'}, 
  {:id => 2317, :name => 'Oplotnica'}, 
  {:id => 2318, :name => 'Laporje'}, 
  {:id => 2319, :name => 'Poljčane'}, 
  {:id => 2321, :name => 'Makole'}, 
  {:id => 2322, :name => 'Majšperk'}, 
  {:id => 2323, :name => 'Ptujska Gora'}, 
  {:id => 2324, :name => 'Lovrenc na Dravskem polju'}, 
  {:id => 2325, :name => 'Kidričevo'}, 
  {:id => 2326, :name => 'Cirkovce'}, 
  {:id => 2327, :name => 'Rače'}, 
  {:id => 2331, :name => 'Pragersko'}, 
  {:id => 2341, :name => 'Limbuš'}, 
  {:id => 2342, :name => 'Ruše'}, 
  {:id => 2343, :name => 'Fala'}, 
  {:id => 2344, :name => 'Lovrenc na Pohorju'}, 
  {:id => 2345, :name => 'Bistrica ob Dravi'}, 
  {:id => 2351, :name => 'Kamnica'}, 
  {:id => 2352, :name => 'Selnica ob Dravi'}, 
  {:id => 2353, :name => 'Sv. Duh na Ostrem Vrhu'}, 
  {:id => 2354, :name => 'Bresternica'}, 
  {:id => 2360, :name => 'Radlje ob Dravi'}, 
  {:id => 2361, :name => 'Ožbalt'}, 
  {:id => 2362, :name => 'Kapla'}, 
  {:id => 2363, :name => 'Podvelka'}, 
  {:id => 2364, :name => 'Ribnica na Pohorju'}, 
  {:id => 2365, :name => 'Vuhred'}, 
  {:id => 2366, :name => 'Muta'}, 
  {:id => 2367, :name => 'Vuzenica'}, 
  {:id => 2370, :name => 'Dravograd'}, 
  {:id => 2371, :name => 'Trbonje'}, 
  {:id => 2372, :name => 'Libeliče'}, 
  {:id => 2373, :name => 'Šentjanž pri Dravogradu'}, 
  {:id => 2380, :name => 'Slovenj Gradec'}, 
  {:id => 2381, :name => 'Podgorje pri Slovenj Gradcu'}, 
  {:id => 2382, :name => 'Mislinja'}, 
  {:id => 2383, :name => 'Šmartno pri Slovenj Gradcu'}, 
  {:id => 2390, :name => 'Ravne na Koroškem'}, 
  {:id => 2391, :name => 'Prevalje'}, 
  {:id => 2392, :name => 'Mežica'}, 
  {:id => 2393, :name => 'Črna na Koroškem'}, 
  {:id => 2394, :name => 'Kotlje'}, 
  {:id => 3000, :name => 'Celje'}, 
  {:id => 3201, :name => 'Šmartno v Rožni dolini'}, 
  {:id => 3202, :name => 'Ljubečna'}, 
  {:id => 3203, :name => 'Nova Cerkev'}, 
  {:id => 3204, :name => 'Dobrna'}, 
  {:id => 3205, :name => 'Vitanje'}, 
  {:id => 3206, :name => 'Stranice'}, 
  {:id => 3210, :name => 'Slovenske Konjice'}, 
  {:id => 3211, :name => 'Škofja vas'}, 
  {:id => 3212, :name => 'Vojnik'}, 
  {:id => 3213, :name => 'Frankolovo'}, 
  {:id => 3214, :name => 'Zreče'}, 
  {:id => 3215, :name => 'Loče'}, 
  {:id => 3220, :name => 'Štore'}, 
  {:id => 3221, :name => 'Teharje'}, 
  {:id => 3222, :name => 'Dramlje'}, 
  {:id => 3223, :name => 'Loka pri Žusmu'}, 
  {:id => 3224, :name => 'Dobje pri Planini'}, 
  {:id => 3225, :name => 'Planina pri Sevnici'}, 
  {:id => 3230, :name => 'Šentjur'}, 
  {:id => 3231, :name => 'Grobelno'}, 
  {:id => 3232, :name => 'Ponikva'}, 
  {:id => 3233, :name => 'Kalobje'}, 
  {:id => 3240, :name => 'Šmarje pri Jelšah'}, 
  {:id => 3241, :name => 'Podplat'}, 
  {:id => 3250, :name => 'Rogaška Slatina'}, 
  {:id => 3252, :name => 'Rogatec'}, 
  {:id => 3253, :name => 'Pristava pri Mestinju'}, 
  {:id => 3254, :name => 'Podčetrtek'}, 
  {:id => 3255, :name => 'Buče'}, 
  {:id => 3256, :name => 'Bistrica ob Sotli'}, 
  {:id => 3257, :name => 'Podsreda'}, 
  {:id => 3260, :name => 'Kozje'}, 
  {:id => 3261, :name => 'Lesično'}, 
  {:id => 3262, :name => 'Prevorje'}, 
  {:id => 3263, :name => 'Gorica pri Slivnici'}, 
  {:id => 3264, :name => 'Sveti Štefan'}, 
  {:id => 3270, :name => 'Laško'}, 
  {:id => 3271, :name => 'Šentrupert'}, 
  {:id => 3272, :name => 'Rimske Toplice'}, 
  {:id => 3273, :name => 'Jurklošter'}, 
  {:id => 3301, :name => 'Petrovče'}, 
  {:id => 3302, :name => 'Griže'}, 
  {:id => 3303, :name => 'Gomilsko'}, 
  {:id => 3304, :name => 'Tabor'}, 
  {:id => 3305, :name => 'Vransko'}, 
  {:id => 3310, :name => 'Žalec'}, 
  {:id => 3311, :name => 'Šempeter v Savinjski dolini'}, 
  {:id => 3312, :name => 'Prebold'}, 
  {:id => 3313, :name => 'Polzela'}, 
  {:id => 3314, :name => 'Braslovče'}, 
  {:id => 3320, :name => 'Velenje'}, 
  {:id => 3325, :name => 'Šoštanj'}, 
  {:id => 3326, :name => 'Topolšica'}, 
  {:id => 3327, :name => 'Šmartno ob Paki'}, 
  {:id => 3330, :name => 'Mozirje'}, 
  {:id => 3331, :name => 'Nazarje'}, 
  {:id => 3332, :name => 'Rečica ob Savinji'}, 
  {:id => 3333, :name => 'Ljubno ob Savinji'}, 
  {:id => 3334, :name => 'Luče'}, 
  {:id => 3335, :name => 'Solčava'}, 
  {:id => 3341, :name => 'Šmartno ob Dreti'}, 
  {:id => 3342, :name => 'Gornji Grad'}, 
  {:id => 4000, :name => 'Kranj'}, 
  {:id => 4201, :name => 'Zgornja Besnica'}, 
  {:id => 4202, :name => 'Naklo'}, 
  {:id => 4203, :name => 'Duplje'}, 
  {:id => 4204, :name => 'Golnik'}, 
  {:id => 4205, :name => 'Preddvor'}, 
  {:id => 4206, :name => 'Zgornje Jezersko'}, 
  {:id => 4207, :name => 'Cerklje na Gorenjskem'}, 
  {:id => 4208, :name => 'Šenčur'}, 
  {:id => 4209, :name => 'Žabnica'}, 
  {:id => 4210, :name => 'Brnik aerodrom'}, 
  {:id => 4211, :name => 'Mavčiče'}, 
  {:id => 4212, :name => 'Visoko'}, 
  {:id => 4220, :name => 'Škofja Loka'}, 
  {:id => 4223, :name => 'Poljane nad Škofjo Loko'}, 
  {:id => 4224, :name => 'Gorenja vas'}, 
  {:id => 4225, :name => 'Sovodenj'}, 
  {:id => 4226, :name => 'Žiri'}, 
  {:id => 4227, :name => 'Selca'}, 
  {:id => 4228, :name => 'Železniki'}, 
  {:id => 4229, :name => 'Sorica'}, 
  {:id => 4240, :name => 'Radovljica'}, 
  {:id => 4243, :name => 'Brezje'}, 
  {:id => 4244, :name => 'Podnart'}, 
  {:id => 4245, :name => 'Kropa'}, 
  {:id => 4246, :name => 'Kamna Gorica'}, 
  {:id => 4247, :name => 'Zgornje Gorje'}, 
  {:id => 4248, :name => 'Lesce'}, 
  {:id => 4260, :name => 'Bled'}, 
  {:id => 4263, :name => 'Bohinjska Bela'}, 
  {:id => 4264, :name => 'Bohinjska Bistrica'}, 
  {:id => 4265, :name => 'Bohinjsko jezero'}, 
  {:id => 4267, :name => 'Srednja vas v Bohinju'}, 
  {:id => 4270, :name => 'Jesenice'}, 
  {:id => 4273, :name => 'Blejska Dobrava'}, 
  {:id => 4274, :name => 'Žirovnica'}, 
  {:id => 4275, :name => 'Begunje na Gorenjskem'}, 
  {:id => 4276, :name => 'Hrušica'}, 
  {:id => 4280, :name => 'Kranjska Gora'}, 
  {:id => 4281, :name => 'Mojstrana'}, 
  {:id => 4282, :name => 'Gozd Martuljek'}, 
  {:id => 4283, :name => 'Rateče-Planica'}, 
  {:id => 4290, :name => 'Tržič'}, 
  {:id => 4294, :name => 'Križe'}, 
  {:id => 5000, :name => 'Nova Gorica'}, 
  {:id => 5210, :name => 'Deskle'}, 
  {:id => 5211, :name => 'Kojsko'}, 
  {:id => 5212, :name => 'Dobrovo v Brdih'}, 
  {:id => 5213, :name => 'Kanal'}, 
  {:id => 5214, :name => 'Kal nad Kanalom'}, 
  {:id => 5215, :name => 'Ročinj'}, 
  {:id => 5216, :name => 'Most na Soči'}, 
  {:id => 5220, :name => 'Tolmin'}, 
  {:id => 5222, :name => 'Kobarid'}, 
  {:id => 5223, :name => 'Breginj'}, 
  {:id => 5224, :name => 'Srpenica'}, 
  {:id => 5230, :name => 'Bovec'}, 
  {:id => 5231, :name => 'Log pod Mangartom'}, 
  {:id => 5232, :name => 'Soča'}, 
  {:id => 5242, :name => 'Grahovo ob Bači'}, 
  {:id => 5243, :name => 'Podbrdo'}, 
  {:id => 5250, :name => 'Solkan'}, 
  {:id => 5251, :name => 'Grgar'}, 
  {:id => 5252, :name => 'Trnovo pri Gorici'}, 
  {:id => 5253, :name => 'Čepovan'}, 
  {:id => 5261, :name => 'Šempas'}, 
  {:id => 5262, :name => 'Črniče'}, 
  {:id => 5263, :name => 'Dobravlje'}, 
  {:id => 5270, :name => 'Ajdovščina'}, 
  {:id => 5271, :name => 'Vipava'}, 
  {:id => 5272, :name => 'Podnanos'}, 
  {:id => 5273, :name => 'Col'}, 
  {:id => 5274, :name => 'Črni Vrh nad Idrijo'}, 
  {:id => 5275, :name => 'Godovič'}, 
  {:id => 5280, :name => 'Idrija'}, 
  {:id => 5281, :name => 'Spodnja Idrija'}, 
  {:id => 5282, :name => 'Cerkno'}, 
  {:id => 5283, :name => 'Slap ob Idrijci'}, 
  {:id => 5290, :name => 'Šempeter pri Gorici'}, 
  {:id => 5291, :name => 'Miren'}, 
  {:id => 5292, :name => 'Renče'}, 
  {:id => 5293, :name => 'Volčja Draga'}, 
  {:id => 5294, :name => 'Dornberk'}, 
  {:id => 5295, :name => 'Branik'}, 
  {:id => 5296, :name => 'Kostanjevica na Krasu'}, 
  {:id => 5297, :name => 'Prvačina'}, 
  {:id => 6000, :name => 'Koper - Capodistria'}, 
  {:id => 6210, :name => 'Sežana'}, 
  {:id => 6215, :name => 'Divača'}, 
  {:id => 6216, :name => 'Podgorje'}, 
  {:id => 6217, :name => 'Vremski Britof'}, 
  {:id => 6219, :name => 'Lokev'}, 
  {:id => 6221, :name => 'Dutovlje'}, 
  {:id => 6222, :name => 'Štanjel'}, 
  {:id => 6223, :name => 'Komen'}, 
  {:id => 6224, :name => 'Senožeče'}, 
  {:id => 6225, :name => 'Hruševje'}, 
  {:id => 6230, :name => 'Postojna'}, 
  {:id => 6232, :name => 'Planina'}, 
  {:id => 6240, :name => 'Kozina'}, 
  {:id => 6242, :name => 'Materija'}, 
  {:id => 6243, :name => 'Obrov'}, 
  {:id => 6244, :name => 'Podgrad'}, 
  {:id => 6250, :name => 'Ilirska Bistrica'}, 
  {:id => 6251, :name => 'Ilirska Bistrica-Trnovo'}, 
  {:id => 6253, :name => 'Knežak'}, 
  {:id => 6254, :name => 'Jelšane'}, 
  {:id => 6255, :name => 'Prem'}, 
  {:id => 6256, :name => 'Košana'}, 
  {:id => 6257, :name => 'Pivka'}, 
  {:id => 6258, :name => 'Prestranek'}, 
  {:id => 6271, :name => 'Dekani'}, 
  {:id => 6272, :name => 'Gračišče'}, 
  {:id => 6273, :name => 'Marezige'}, 
  {:id => 6274, :name => 'Šmarje'}, 
  {:id => 6275, :name => 'Črni Kal'}, 
  {:id => 6276, :name => 'Pobegi'}, 
  {:id => 6280, :name => 'Ankaran - Ancarano'}, 
  {:id => 6281, :name => 'Škofije'}, 
  {:id => 6310, :name => 'Izola - Isola'}, 
  {:id => 6320, :name => 'Portorož - Portorose'}, 
  {:id => 6323, :name => 'Strunjan - Strugnano (sezonska pošta)'}, 
  {:id => 6330, :name => 'Piran - Pirano'}, 
  {:id => 6333, :name => 'Sečovlje - Sicciole'}, 
  {:id => 8000, :name => 'Novo mesto'}, 
  {:id => 8210, :name => 'Trebnje'}, 
  {:id => 8211, :name => 'Dobrnič'}, 
  {:id => 8212, :name => 'Velika Loka'}, 
  {:id => 8213, :name => 'Veliki Gaber'}, 
  {:id => 8216, :name => 'Mirna Peč'}, 
  {:id => 8220, :name => 'Šmarješke Toplice'}, 
  {:id => 8222, :name => 'Otočec'}, 
  {:id => 8230, :name => 'Mokronog'}, 
  {:id => 8231, :name => 'Trebelno '}, 
  {:id => 8232, :name => 'Šentrupert'}, 
  {:id => 8233, :name => 'Mirna'}, 
  {:id => 8250, :name => 'Brežice'}, 
  {:id => 8251, :name => 'Čatež ob Savi'}, 
  {:id => 8253, :name => 'Artiče'}, 
  {:id => 8254, :name => 'Globoko'}, 
  {:id => 8255, :name => 'Pišece'}, 
  {:id => 8256, :name => 'Sromlje '}, 
  {:id => 8257, :name => 'Dobova'}, 
  {:id => 8258, :name => 'Kapele'}, 
  {:id => 8259, :name => 'Bizeljsko'}, 
  {:id => 8261, :name => 'Jesenice na Dolenjskem'}, 
  {:id => 8262, :name => 'Krška vas'}, 
  {:id => 8263, :name => 'Cerklje ob Krki'}, 
  {:id => 8270, :name => 'Krško'}, 
  {:id => 8272, :name => 'Zdole '}, 
  {:id => 8273, :name => 'Leskovec pri Krškem'}, 
  {:id => 8274, :name => 'Raka'}, 
  {:id => 8275, :name => 'Škocjan'}, 
  {:id => 8276, :name => 'Bučka '}, 
  {:id => 8280, :name => 'Brestanica'}, 
  {:id => 8281, :name => 'Senovo'}, 
  {:id => 8282, :name => 'Koprivnica'}, 
  {:id => 8283, :name => 'Blanca'}, 
  {:id => 8290, :name => 'Sevnica'}, 
  {:id => 8292, :name => 'Zabukovje '}, 
  {:id => 8293, :name => 'Studenec'}, 
  {:id => 8294, :name => 'Boštanj'}, 
  {:id => 8295, :name => 'Tržišče'}, 
  {:id => 8296, :name => 'Krmelj'}, 
  {:id => 8297, :name => 'Šentjanž'}, 
  {:id => 8310, :name => 'Šentjernej'}, 
  {:id => 8311, :name => 'Kostanjevica na Krki'}, 
  {:id => 8312, :name => 'Podbočje'}, 
  {:id => 8321, :name => 'Brusnice'}, 
  {:id => 8322, :name => 'Stopiče'}, 
  {:id => 8323, :name => 'Uršna sela'}, 
  {:id => 8330, :name => 'Metlika'}, 
  {:id => 8331, :name => 'Suhor'}, 
  {:id => 8332, :name => 'Gradac'}, 
  {:id => 8333, :name => 'Semič'}, 
  {:id => 8340, :name => 'Črnomelj'}, 
  {:id => 8341, :name => 'Adlešiči'}, 
  {:id => 8342, :name => 'Stari trg ob Kolpi'}, 
  {:id => 8343, :name => 'Dragatuš'}, 
  {:id => 8344, :name => 'Vinica'}, 
  {:id => 8350, :name => 'Dolenjske Toplice'}, 
  {:id => 8351, :name => 'Straža'}, 
  {:id => 8360, :name => 'Žužemberk'}, 
  {:id => 8361, :name => 'Dvor'}, 
  {:id => 8362, :name => 'Hinje'}, 
  {:id => 9000, :name => 'Murska Sobota'}, 
  {:id => 9201, :name => 'Puconci'}, 
  {:id => 9202, :name => 'Mačkovci'}, 
  {:id => 9203, :name => 'Petrovci'}, 
  {:id => 9204, :name => 'Šalovci'}, 
  {:id => 9205, :name => 'Hodoš - Hodos'}, 
  {:id => 9206, :name => 'Križevci'}, 
  {:id => 9207, :name => 'Prosenjakovci - Partosfalva'}, 
  {:id => 9208, :name => 'Fokovci'}, 
  {:id => 9220, :name => 'Lendava - Lendva'}, 
  {:id => 9221, :name => 'Martjanci'}, 
  {:id => 9222, :name => 'Bogojina'}, 
  {:id => 9223, :name => 'Dobrovnik - Dobronak '}, 
  {:id => 9224, :name => 'Turnišče'}, 
  {:id => 9225, :name => 'Velika Polana'}, 
  {:id => 9226, :name => 'Moravske Toplice'}, 
  {:id => 9227, :name => 'Kobilje'}, 
  {:id => 9231, :name => 'Beltinci'}, 
  {:id => 9232, :name => 'Črenšovci'}, 
  {:id => 9233, :name => 'Odranci'}, 
  {:id => 9240, :name => 'Ljutomer'}, 
  {:id => 9241, :name => 'Veržej'}, 
  {:id => 9242, :name => 'Križevci pri Ljutomeru'}, 
  {:id => 9243, :name => 'Mala Nedelja'}, 
  {:id => 9244, :name => 'Sv. Jurij ob Ščavnici'}, 
  {:id => 9245, :name => 'Spodnji Ivanjci'}, 
  {:id => 9250, :name => 'Gornja Radgona'}, 
  {:id => 9251, :name => 'Tišina'}, 
  {:id => 9252, :name => 'Radenci'}, 
  {:id => 9253, :name => 'Apače'}, 
  {:id => 9261, :name => 'Cankova'}, 
  {:id => 9262, :name => 'Rogašovci'}, 
  {:id => 9263, :name => 'Kuzma'}, 
  {:id => 9264, :name => 'Grad'}, 
  {:id => 9265, :name => 'Bodonci'}
])
