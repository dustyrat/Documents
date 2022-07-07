	def beforeValidate(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("************************BeforeValidate**************************\n")
			Map<String, Object> properties = this.getProperties()
			properties.each { key, value ->
				info.append("\t${key}: ${value.toString().replaceAll('\n','\n\t\t ')}\n")
			}
			info.append("************************BeforeValidate**************************\n")
			log.debug info
		}
	}

	def beforeInsert(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("************************BeforeInsert**************************\n")
			Map<String, Object> properties = this.getProperties()
			properties.each { key, value ->
				info.append("\t${key}: ${value.toString().replaceAll('\n','\n\t\t ')}\n")
			}
			info.append("************************BeforeInsert**************************\n")
			log.debug info
		}
	}

	def afterInsert(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("************************AfterInsert**************************\n")
			Map<String, Object> properties = this.getProperties()
			properties.each { key, value ->
				info.append("\t${key}: ${value.toString().replaceAll('\n','\n\t\t ')}\n")
			}
			info.append("************************AfterInsert**************************\n")
			log.debug info
		}
	}

	def beforeUpdate(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("************************BeforeUpdate**************************\n")
					.append("isDirty: ${this.isDirty()}\n")
			if (this.isDirty()){
				List<String> properties = this.getDirtyPropertyNames()
				properties.each { property ->
					info.append("\t${property}: ${this.getPersistentValue(property)} -> ${this.getProperty(property)}\n")
				}
			}
			info.append("************************BeforeUpdate**************************\n")
			log.debug info
		}
	}

	def afterUpdate(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("************************AfterUpdate**************************\n")
			Map<String, Object> properties = this.getProperties()
			properties.each { key, value ->
				info.append("\t${key}: ${value.toString().replaceAll('\n','\n\t\t ')}\n")
			}
			info.append("************************AfterUpdate**************************\n")
			log.debug info
		}
	}

	def beforeDelete(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("**************************BeforeDelete**************************\n")
			Map<String, Object> properties = this.getProperties()
			properties.each { key, value ->
				info.append("\t${key}: ${value.toString().replaceAll('\n','\n\t\t ')}\n")
			}
			info.append("************************BeforeDelete**************************\n")
			log.debug info
		}
	}

	def afterDelete(){
		if (log.debugEnabled){
			StringBuilder info = new StringBuilder().append("${this}\n")
					.append("************************AfterDelete**************************\n")
			Map<String, Object> properties = this.getProperties()
			properties.each { key, value ->
				info.append("\t${key}: ${value.toString().replaceAll('\n','\n\t\t ')}\n")
			}
			info.append("************************AfterDelete**************************\n")
			log.debug info
		}
	}
