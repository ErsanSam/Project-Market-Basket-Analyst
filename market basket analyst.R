#Menggunakan library arules
library(arules)

#Membaca transaksi dari file data_transaksi.txt
transaksi <- read.transactions(file="https://storage.googleapis.com/dqlab-dataset/data_transaksi.txt", format="single", sep="\t", cols=c(1,2), skip=1)

print(transaksi)#Menampilkan data transaksi dengan print

#Menampilkan Daftar Item Transaksi
transaksi@itemInfo

#Menampilkan Daftar Kode Transaksi
transaksi@itemsetInfo

#Tampilan Transaksi dalam bentuk Matrix
transaksi@data

#Item Frequency
itemFrequency(transaksi)
itemFrequency(transaksi, type="absolute")

  ##Statistik Top 3

data_item <- itemFrequency(transaksi, type="absolute")
print(data_item)
#Melakukan sorting pada data_item
data_item <- sort(data_item, decreasing = TRUE)
print(data_item)
#Mengambil 3 item pertama
data_item <- data_item[1:3]
print(data_item)
#Konversi data_item menjadi data frame dengan kolom Nama_Produk dan Jumlah
data_item <- data.frame("Nama Produk"=names(data_item), "Jumlah"=data_item, row.names=NULL)
print(data_item)

#Output Statistik Top 3 Sebagai File
write.csv(data_item, file="top3_item_retail.txt", eol = "\r\n")
#Grafik Item Frequency dengan itemFrequencyPlot()
itemFrequencyPlot(transaksi)
#______________________________________________________________
    #Itemset and Rules
#Melihat Itemset per Transaksi dengan Inspect
inspect(transaksi)
#Menghasilkan Rules dengan Apriori, masukkan ke variable mba
mba <- apriori(transaksi)
#Melihat Rules dengan fungsi inspect
inspect(mba)
#Filter RHS
inspect(subset(mba, rhs %in% "Sirup"))
#Filter LHS
inspect(subset(mba, lhs %in% "Gula"))
#Filter LHS dan RHS
inspect(subset(mba,lhs %in% "Pet Food"&rhs %in% "Sirup"))
#______________________________________________________________
#Scoring and Evaluation: Support, Confidence and Lift
#Menghasilkan Rules dengan Parameter Support dan Confidence
apriori(transaksi,parameter = list(supp = 0.1, confidence = 0.5))
#Inspeksi Rules Yang Dihasilkan
mba <- apriori(transaksi,parameter = list(supp = 0.1, confidence = 0.5))
inspect(mba)
#Filter LHS dan RHS (2)
inspect(subset(mba, lhs %in% "Teh Celup" | rhs %in% "Teh Celup"))
#Filter berdasarkan Lift
inspect(subset(mba, (lhs %in% "Teh Celup" | rhs %in% "Teh Celup") & lift>1))
#Rekomendasi - Filter dengan %ain%
inspect(subset(mba, (lhs %ain% c("Pet Food", "Gula" ))))
#Visualisasi Rules dengan Graph
library(arulesViz)
plot(subset(mba, lift>1.1), method="graph")
