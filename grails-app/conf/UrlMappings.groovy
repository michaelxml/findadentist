class UrlMappings {

	static mappings = {
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"(view:"/index-responsive3")
		"/responsive"(view:"/index-responsive3")
		"500"(view:'/error')
	}
}
