enum CountyAdjacency {
    static let map: [String: Set<String>] = [
        "YEAR_11": ["YEAR_12", "YEAR_15", "YEAR_16","YEAR_20", "YEAR_23","YEAR_26"],
        "YEAR_12": ["YEAR_11","YEAR_24","YEAR_26"],
        "YEAR_13": ["YEAR_15","YEAR_18","YEAR_20"],
        "YEAR_14": ["YEAR_18","YEAR_19","YEAR_20","YEAR_22","YEAR_25"],
        "YEAR_15": ["YEAR_11","YEAR_13","YEAR_20"],
        "YEAR_16": ["YEAR_11","YEAR_21","YEAR_23","YEAR_24","YEAR_26","YEAR_28"],
        "YEAR_17": ["YEAR_21","YEAR_27","YEAR_28"],
        "YEAR_18": ["YEAR_13","YEAR_14","YEAR_20","YEAR_25"],
        "YEAR_19": ["YEAR_14","YEAR_20","YEAR_22","YEAR_23"],
        "YEAR_20": ["YEAR_11","YEAR_13","YEAR_14","YEAR_15","YEAR_18","YEAR_19","YEAR_23"],
        "YEAR_21": ["YEAR_16","YEAR_17","YEAR_23","YEAR_28"],
        "YEAR_22": ["YEAR_14","YEAR_19","YEAR_23"],
        "YEAR_23": ["YEAR_11","YEAR_16","YEAR_19","YEAR_20","YEAR_21","YEAR_22"],
        "YEAR_24": ["YEAR_12","YEAR_16","YEAR_26","YEAR_28","YEAR_29"],
        "YEAR_25": ["YEAR_14","YEAR_18"],
        "YEAR_26": ["YEAR_11","YEAR_12","YEAR_16","YEAR_24"],
        "YEAR_27": ["YEAR_17","YEAR_28","YEAR_29"],
        "YEAR_28": ["YEAR_16","YEAR_17","YEAR_21","YEAR_24","YEAR_27","YEAR_29"],
        "YEAR_29": ["YEAR_24","YEAR_27","YEAR_28"]
    ]
}
