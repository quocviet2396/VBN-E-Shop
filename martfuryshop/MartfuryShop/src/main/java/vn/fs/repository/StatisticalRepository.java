package vn.fs.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import vn.fs.entity.Product;

@Repository
public interface StatisticalRepository extends JpaRepository<Product, Long> {

	@Query(value = "select sum(amount), month(order_date) from orders where year(order_date) = ? and status = 2 group by month(order_date)", nativeQuery = true)
	List<Object[]> getMonthOfYear(int year);

	@Query(value = "select year(order_date) from orders group by year(order_date)", nativeQuery = true)
	List<Integer> getYears();

	@Query(value = "select sum(amount) from orders where year(order_date) = ? and status = 2", nativeQuery = true)
	Double getRevenueByYear(int year);

	@Query(value = "SELECT \n" +
			"    SUM(p.sold) AS total_sold, \n" +
			"    c.category_name, \n" +
			"    (SUM(p.price * p.sold) - SUM(p.discount * p.sold)) AS total_revenue\n" +
			"FROM \n" +
			"    categories c\n" +
			"JOIN \n" +
			"    products p \n" +
			"ON \n" +
			"    p.category_id = c.category_id\n" +
			"GROUP BY \n" +
			"    c.category_name;\n",
			nativeQuery = true)
	List<Object[]> getCategoryBestSeller();

}
