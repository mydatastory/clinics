# Read the genusMicrobiome file into a base dataframe (df).

df <-read.csv("genusMicrobiome.csv", header = TRUE, stringsAsFactors = FALSE)

# Set s1 contains bacterial species found in babies born naturally but not in babies 
# born via c-section.

s1 <- subset(df, natural_newborn_avg > 0 & csect_newborn_avg <= 0)
s1 <- df[df$natural_newborn_avg > 0 & df$csect_newborn_avg <= 0,]

s1$genus

opar <- par(no.readonly = TRUE)

# Adjust the plot margins (bottom, left, top, right).

par(mai = c(1.25, .75, .25, .25))

barplot(s1$natural_newborn_avg, 
        names.arg = s1$genus,
        las       = 2,
        cex.names = .70,
        cex.axis  = .70, 
        col = 'lightblue')

par(opar)


# Set s2 contains bacterial species found in 4 month olds born naturally but not in 
# babies born via c-section.

s2 <- subset(df, natural_4m_avg > 0 & csect_4m_avg <= 0)
s2 <- df[df$natural_4m_avg > 0 & df$csect_4m_avg <= 0,]

s2$genus

# Set s3 contains bacterial species found in 12 month olds born naturally but not in 
# babies born via c-section.

s3 <- subset(df, natural_12m_avg > 0 & csect_12m_avg <= 0)
s3 <- df[df$natural_12m_avg > 0 & df$csect_12m_avg <= 0,]

s3$genus

opar <- par(no.readonly = TRUE)

# Adjust the plot margins (bottom, left, top, right).

par(mai = c(1.25, .75, .25, .25))

barplot(s3$natural_12m_avg, 
        names.arg = s3$genus,
        las       = 2,
        cex.names = .70,
        cex.axis  = .70, 
        col = 'lightblue')

par(opar)

# Set s4 contains bacterial species found in newborns born via c-section but not in 
# babies born naturally.

s4 <- subset(df, natural_newborn_avg <= 0 & csect_newborn_avg > 0)
s4 <- df[df$natural_newborn_avg <= 0 & df$csect_newborn_avg > 0,]

s4$genus

# Set s5 contains bacterial species found in 4 month olds born via c-section but not in 
# babies born naturally.

s5 <- subset(df, natural_4m_avg <= 0 & csect_4m_avg > 0)
s5 <- df[df$natural_4m_avg <= 0 & df$csect_4m_avg > 0,]

s5$genus

# Set s6 contains bacterial species found in 12 month olds born via c-section but not in 
# babies born naturally.

s6 <- subset(df, natural_12m_avg <= 0 & csect_12m_avg > 0)
s6 <- df[df$natural_12m_avg <= 0 & df$csect_12m_avg > 0,]

s6$genus

# www.datasciencemadesimple.com/join-in-r-merge-in-r/
  
s7 <- df[df$natural_newborn_avg > 0,]
s7 <- data.frame(s7$genus, s7$natural_newborn_avg)

s8 <- df[df$csect_newborn_avg > 0,]
s8 <- data.frame(s8$genus, s8$csect_newborn_avg)

