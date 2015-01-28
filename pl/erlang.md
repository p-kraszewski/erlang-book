# O książce

## Licencja

*Zapiski na pudełku dyskietek* są dostępne na licencji *Attribution-NonCommercial-NoDerivatives 4.0 International*. Powinieneś uzyskać ten egzemplarz bezpłatnie.

Masz prawo kopiować i rozpowszechniać tą publikację, jednak zawsze powinieneś wskazać moje (Pawła Kraszewskiego) autorstwo i nie używać jej do celów komercyjnych.

Tekst licencji znajduje się na stronie [CC BY-NC-ND 4.0 PL](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.pl)

## Najnowsza wesja

Kod źródłowy najnowszej wersji książki znajduje się zawsze pod adresem [github.com/p-kraszewski/erlang-book](https://github.com/p-kraszewski/erlang-book)

# Część 1. Instalacja i test.

W przeciwieństwie do innych kursów, tzw. „podręcznikowych” - ja zacznę od drugiej strony, od przykładowych skryptów i aplikacji, tłumacząc składnię, struktury i „zasady” w trakcie skryptu. Czyli pierw przykład, potem tłumaczenie co, jak i dlaczego. Kurs zacznę od razu z grubej rury, czyli od tego po co Erlang w ogóle powstał.

## O języku
Najpierw wpis ze strony [Wikipedii](http://pl.wikipedia.org/wiki/Erlang_(j%C4%99zyk_programowania))

> Erlang jest językiem programowania ogólnego przeznaczenia zaprojektowanym z myślą o **zastosowaniach współbieżnych**, a także **środowiskiem uruchomieniowym** dla aplikacji w nim napisanych. Sekwencyjny podzbiór Erlanga jest **językiem funkcyjnym** z wartościowaniem zachłannym, **jednokrotnym przypisaniem** oraz **dynamicznym typowaniem**. Część współbieżna bazuje na teoretycznym modelu znanym jako **Actor model**. Język został zaprojektowany pod kątem tworzenia **rozproszonych** systemów wymagających **długotrwałej pracy** oraz **odporności na awarie**. Obsługuje mechanizm hot-swappingu pozwalający na **aktualizację kodu aplikacji bez jej zatrzymywania**. Język został zaprojektowany w 1986 roku przez Joe Armstronga pracującego w firmie Ericsson. Początkowo był własnościowym narzędziem tej firmy, lecz w roku 1998 wraz z implementacją i bibliotekami, stał się oprogramowaniem **open source**. Nazwa Erlang została nadana na cześć A. K. Erlanga, choć często bywa również interpretowana jako ERicsson LANGuage.

Wytłuszczenia moje wypunktowują kluczowe cechy języka. Od siebie dorzucę: zapewne całkiem bez znaczenia w wyborze nazwy był fakt, że jednostką natężenia ruchu telekomunikacyjnego (Ericsson, hello!) jest… Erlang?

## Skąd zdobyć

Głównym żródłem instalatorów Erlanga jest strona domowa projektu pod adresem [www.erlang.org](http://www.erlang.org). Znajdziecie tam kod źródłowy, dokumentację i pakiety instalacyjne dla systemu Windows. Dodatkowym źródłem pakietów z Erlangiem jest strona Erlang Solutions pod adresem [www.erlang-solutions.com](https://www.erlang-solutions.com/) - także zawierająca kod źródłowy Erlanga wraz z instalatorami dla Windows. Dodatkowo jednak na tej stronie znajdziecie skompilowane wersje oraz repozytoria dla różnych dystrybucji Linuksa oraz dla MacOS-a X. O ile praktycznie wszystkie Linuksy mają w swoich pakietach jakąś wersję Erlanga, jednak jest ona często nieaktualna, często o całą generację. Dlatego warto dodać repozytorium *Erlang Solutions*, zawsze zawierające najnowszą dostępną wersję Erlanga.

Dla tej książki warto zainstalować Erlanga w wersji co najmniej **17.0**.

## Test instalacji
Współpracować będziemy z 2 podstawowymi aplikacjami:

* __erl__ – interpreter poleceń, z nim będziemy współpracować bezpośrednio.
* __erlc__ – kompilator. Można go wywołać też z poziomu erl.

Na początek uruchamiamy interpreter (polecenie erl w linii komend. W przypadku Windows może być potrzeba dodania katalogu Erlanga do ścieżki – po szczegóły odsyłam do helpa Windowsowego :p). Powinno pojawiś się następujące (bądź podobne) zgłoszenie:
```
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:8:8] [async-threads:16] [hipe] [kernel-poll:true]

Eshell V6.3  (abort with ^G)
1> 
```
W skrócie, co to znaczy (wpisy użyteczne dla nas):

* **17** to numer wersji całego pakietu
* **erts-6.3** to numer wersji maszyny wirtualnej,
* **smp:8:8** to ilość dostępnych i ilość wykorzystywanych przez Erlanga procesorów 
* **async-threads:16** to ilość wątków asynchronicznych (tj. obsługiwanych przez system operacyjny) dostępnych dla maszyny wirtualnej. Włączenie można wymusić przez parametr *+A ile_wątków*.
* **hipe** to informacja, że jest obsługiwany kompilator do natywnego kodu procesora (optymalizacja!). Działa automatyczne, gdy zainstalujemy odpowiednią wersję Erlanga (często pakiet ma -hipe- w nazwie) i dodamy odpowiednie flagi do kompilatora *erlc*
* **kernel-poll:true** to informacja, czy maszyna wykorzystuje szybki mechanizm epoll zamiast wolnego poll/select do komunikacji z plikami i urządzeniami. Włączenie można wymusić przez parametr *+K true*
* **Eshell V6.3** to wersja powłoki Erlanga i informacja, że powłokę opuszczamy naciskając Control-G.
* **1>** to informacja, że jesteśmy przy pierwszym poleceniu dla węzła nie mającego nazwy (tym za chwilę).

Dobra, to teraz zamykamy interpreter – naciskamy `Control-G` a następnie `q` i `Enter`.

### Praca w sieci

Jak podkreśliłem, Erlang służy do pisania systemów rozproszonych. Jak to zacząć? Odpal dwie konsole linii komend i w pierwszej wpisz

```
erl -sname alpha
```

a w drugiej

```
erl -sname beta
```

W konsolach powinno pojawić się trochę inne zgłoszenie Erlanga:

```
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:8:8] [async-threads:16] [hipe] [kernel-poll:true]

Eshell V6.3  (abort with ^G)
(alpha@nazwakomputera)1> 
```

Najważniejsza jest ostatnia linijka – przed numerem polecenia pojawił się wpis podobny do adresu e-mail (w drugiej konsoli powinno to brzmieć `(beta@nazwakomputera)1>`). Jest to tak zwany identyfikator węzła, służący do komunikacji między instancjami Erlanga. Zamiast nazwakomputera będzie oczywiście rzeczywista nazwa Twojego komputera. Ważne, Erlang rozróżnia duże i małe litery w całym identyfikatorze węzła, więc po nazwie `beta@NazwaKomputera` się nie podłączymy.

Teraz przechodzimy do okienka z instancją alpha i wydajemy następujące polecenie (pamiętając o zmianie `nazwakomputera` na poprawną):

```
net:ping('beta@nazwakomputera').
```

Jeżeli wszystko zadziała poprawnie, powinniśmy zobaczyć następujące wpisy w okienku:

```
(alpha@nazwakomputera)1> net:ping('beta@nazwakomputera').
pong
(alpha@nazwakomputera)2>
```

Krótko o tym co widać:

* Komendy generalnie pisze się małymi literami. 
* `net:ping` oznacza, że wywołujemy funkcję `ping` z modułu `net`.
* Polecenia kończymy kropką.
* `'beta@nazwakomputera'` to nie jest string (!!!). To tzw. atom, odpowiednik `#define` bądź globalnego `enum` z C/C++ czy ``:identyfikatora` z Rubiego. Atom jest „nierozbieralny” i możecie go traktować jako „coś” co można tylko i wyłącznie przypisywać i porównywać równe-różne. Atomy nie mają sensu słownikowego i porównania większy-mniejszy nie mają sensu. Normalnie też nie da się też „zajrzeć” do atomu i zobaczyć z czego powstał. Generalnie atom ma postać ciągu znaków rozpoczynającego się od małej litery i zawierającego znaki a-z, A-Z, 0-9 i _. Przykładami takich atomów są `atom`, `inny_atom`, `atomJakWielblad` i `atom17`. Zwróć uwagę – nie ma żadnych cudzysłowów, apostrofów! Jeżeli potrzebujesz zrobić atom zawierający inne znaki, w tym spację, bądź zaczynający się od wielkiej litery, dajesz go między apostrofy. Na przykład `'atom ze spacjami'`, `'Atom_z_duzej_litery'` czy `'wezel@komputer.gdzies.pl'`. Umieszczenie w apostrofach atomu nie potrzebującego w nich być nie jest błędem, więc jak masz wątpliwości czy trzeba, czy nie – to daj atom w apostrofy dla pewności.
* Na polecenie `ping` Erlang odpowiedział atomem `pong`. Oznacza to, że wywołany węzeł jest dostępny i chce rozmawiać.
* Nowe zgłoszenie kończy się dwójką, czyli system jest gotów na następne polecenie.

Dobrze – to spróbujmy więc wywołać nieistniejący węzeł:

```
(alpha@nazwakomputera)2> net:ping('nie_ma_mnie@nazwakomputera').
pang
(alpha@nazwakomputera)3>
```

Zwróć uwagę – Erlang nie wysypał się ani nie zgłosił błędu. Po prostu zwrócił atom `pang` (zamiast poprawnego `pong`) aby zakomunikować, że węzeł nie działa. Generalnie, jeżeli coś się ewidentnie nie popierdzieli, to preferowane jest zwracanie błędów odpowiednimi atomami – błąd w znaczeniu Erlanga to coś naprawdę poważnego (generalnie często nienaprawialnego).
Na koniec jeszcze małe odpytanie:

```
(alpha@nazwakomputera)3> node().
alpha@nazwakomputera
(alpha@nazwakomputera)4> nodes().
[beta@nazwakomputera]
(alpha@nazwakomputera)5>
```

* Polecenie `node()` zwraca nazwę naszego węzła jako atom.
* Polecenie `nodes()` zwraca listę (dlatego wynik jest w nawiasach kwadratowych) atomów-nazw pozostałych węzłów w sieci.

To tyle na dziś, w następnej części zrobimy mały (jak piszę mały, to mam na myśli naprawdę mały) serwer odpowiadający na wywołania przez sieć.

# Przykład

```erlang
-module(hello).
-export([hello_world/0]).

hello_world() ->
	io:fwrite("hello, world\n").
```
