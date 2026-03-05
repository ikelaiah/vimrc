def calculate_total(price, tax_rate):
    subtotal = price * tax_rate
    return price + subtotal

if __name__ == "__main__":
    total = calculate_total(120, 0.1)
    print("Total:", total)
