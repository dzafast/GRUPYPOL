class Grupypol
   # Program do przetwarzania pliku *.wozek na pojedyńcze pliki w formacie *.pgrp
   # zawierające dane do obslugi wozkow posczegolnych obiektow zasilających na zobrazowaniu Nastawni Centralnych,
   # Wymagany katalog wozek w ktorym tworzymy katalogi o dowolnych nazwach np. ilawa, krakow, katowice
   # nastepnie w powyzszych katalogach umieszczamy wygenerowany plik np. ilawa.wozek
   def initialize
      system 'cls'
      dane_wejsciowe
      koniec
   end

   def dane_wejsciowe
      until @root =~ @maska_koniec
         @maska_koniec = /end/i
         #zmienna przechowująca katalog do przszukania
         @programy_name = "wozek"
         puts ""
         puts "".center(80, '-')
         print "    Zawartość katalogu / #{@programy_name}  ".center(80)
         puts ""
         puts "".center(80, '-')

         # Przeszukanie katalogow oraz wyszukanie pliku z rozszrzeniem *.wozkek i wyświetlenie jego zawartości z pelna ściezka katakogu
         #Dir.glob(File.join(programy_name, "**", "*.wozek*")).each do |start|
            #puts start
         #end

         # Przeszukanie katalogu wozki i wyświetlenie jego zawartości z pominięciem pełnej ściezki
         Dir.foreach(@programy_name) do |start|
            puts start
         end

         puts ""
         puts ""
         puts "".center(80, '-')
         print "    wpisz nazwę katalogu lub (end) aby zaończyć pracę  ".center(80)
         puts ""
         puts "".center(80, '-')
         print  "  =>  "
         # Przekazanie przez usera nazwy katalogu
         root = gets.chomp

         # Zmienna przechowujaca sciezke do zadanego katalogu
         new_directory = File.join("#{@programy_name}", "#{root}")

         if Dir.exists? new_directory
            @maska_koniec = /end/i
            # Utworzenie nazwy pliku z czlonem nazwy katalogu np. ilawa.wozek
            file = "#{root}.wozek"
            file = file.capitalize

            # przeszukanie katalogu Programy/wozek/root i wyświetlenie jego zawartości
            # metoda join łączy wszystkie argumenty w cudzychsłowach w jedną ściezkę dostepu
            dir = Dir.entries(File.join("#{@programy_name}", "#{root}")).each { |e| puts "#{e}" }
            puts ""

            # Sprawdzenie czy plik file znajduje się w katalogu dir
            if dir.include?(file)
               @root = root
               @file = file
               przetworzenie_danych
            else
               puts ""
               puts "".center(80, '!')
               puts "W katalogu #{root}, nie znalazłem pliku #{root}.wozek".center(80)
               puts ""
               puts "".center(80, '!')
               dane_wejsciowe
            end
         elsif root =~ @maska_koniec
            koniec
         else
            puts ""
            puts "".center(80, '!')
            puts "Nie ma takiego katalogu!  #{root}".center(80)
            puts "".center(80, '!')
            dane_wejsciowe
         end
      end
   end

   def przetworzenie_danych
      savedirect = File.join("#{@programy_name}", "#{@root}", "GRUPYPOL")
      directory = File.join("#{@programy_name}", "#{@root}", "#{@file}")
      File.foreach(directory) do |zawartosc|
         zawartosc.each_line do |file|
            # Przetworzenie łańcucha znakwow w tablicę, wyrazenie regularne /\w+/ rozdziela poszczegolne słowa stringa.
            # np scan /\w/ podzieli stringa na poszczegolne znaki, pomijając spacje
            # np chars.to_a podzieli stringa na poszczegolne znaki, uwzględniając spacje
            file = file.scan /\w+/
            nr_st = file[1].to_i
               if nr_st <= 9
                  dwazera = "00"
                  nr_stan = dwazera + nr_st.to_s
               elsif nr_st <= 99
                  zero = "0"
                  nr_stan = zero + nr_st.to_s
               else
                  nr_stan = nr_st
               end
            obj, pb, pc = file[4], file[5], file[6]
            wozek_nazwa = "#{nr_stan}_#{obj}.pgrp"
            if Dir.exists? savedirect
               Dir.chdir(savedirect) do |plik|
                  plik = File.open("#{wozek_nazwa}", "w") do |raport|
                     raport.puts "#{nr_stan},#{pb}"
                     raport.puts "#{nr_stan},#{pc}"
                  end
               end
            else
               Dir.mkdir savedirect
               puts "".center(80, '+')
               puts ""
               puts "katalog GRUPYPOL w #{@root} został utworzony".center(80)
               puts ""
            end
         end
      end
      puts "".center(80, '+')
      puts ""
      puts "Pliki *.PGRP dla #{@root} zapisane!".center(80)
      puts ""
      puts "".center(80, '+')
      dane_wejsciowe
   end

   def koniec
      puts "Nacisnij [enter]".center(80)
      gets
      puts "Do widzenia".center(80)
      exit
   end
end

grupypol = Grupypol.new
